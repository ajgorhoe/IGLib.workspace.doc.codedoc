// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Text;

namespace IG.Lib.Events
{


    // Remark: ValueTuple<Type, Type, Type> is efficient to use as access key for subscriptions because it is a value type and it implements 
    // properly the IEquatable<T> interface and GetHashCode(). Though not immutable, its elements are copied on assignment (not just referenc
    // is assigned, which would make possible to change the key after using it when passed via variable).
    // See e.g. this blog: https://montemagno.com/optimizing-c-struct-equality-with-iequatable/
    // Or: https://stackoverflow.com/questions/53831071/are-valuetuples-suitable-as-dictionary-keys

    /// <summary>Generic event aggregator.</summary>
#if !VALUETUPLE_AVAILABLE
    public class EventAggregatorGeneric : EventAggregatorGeneric<(Type, Type)>, 
        IEventAggregatorGeneric
    {
        protected override (Type, Type) CreateKey(Type senderType, Type eventArgsType)
        {
            return (senderType, eventArgsType);
        }
    }

#else
    public class EventAggregatorGeneric: EventAggregatorGeneric<EventTypeKey>, IEventAggregatorGeneric
    {
        protected override EventTypeKey CreateKey(Type senderType, Type eventArgsType)
        {
            return new EventTypeKey(senderType, eventArgsType);
        }

        protected override Dictionary<EventTypeKey, List<INotificationSubscription>> CreateDictionary()
        {
            return new Dictionary<EventTypeKey, List<INotificationSubscription>>(
                new EventTypeKeyEqualityComparer()
                );
        }
    }

#endif



    /// <summary>Base class for implementations of <see cref="IEventAggregatorGeneric"/> with different type of keys (<typeparamref name="TKey"/>)
    /// used to access event subscriptions. This was necessary because normally a <see cref="ValueTuple{Type, Type, Type}"/>  would be used, but this
    /// is only available in .NET 4.7 or later (unless installing the ValusType package).
    /// <see cref=""/></summary>
    /// <typeparam name="TKey"></typeparam>
    public abstract class EventAggregatorGeneric<TKey>: IEventAggregatorGeneric
    {

        protected EventAggregatorGeneric()
        {
            Subscriptions = CreateDictionary();
        }

        protected virtual Dictionary<TKey, List<INotificationSubscription>> CreateDictionary()
        {
            return new Dictionary<TKey, List<INotificationSubscription>>();

        }

        /// <summary>Used for locking internal resources in objects of this class and inherited classes to provide 
        /// thread safe operations.</summary>
        protected object Lock { get; } = new object();

        protected virtual Dictionary<TKey, List<INotificationSubscription>> Subscriptions { get; }

        //= new Dictionary<TKey, List<INotificationSubscription>>();


        /// <inheritdoc/>
        public virtual void PublishNotification<TSender, TEventArgs>(TSender sender, TEventArgs eventArgs)
            where TSender : class 
        {
            // Obtain access key for the specified type of notifications:
            TKey key = CreateKey<TSender, TEventArgs>();
            // get a read-only current collection (copy from the live structure) of matching subscriptions, which are 
            // thread-safe for read operations because the array is a copy (contained references are original references):
            var matchingSubsctiptions = GetMatchingSubscriptionsCollectionCopy(key);
            if (matchingSubsctiptions == null)
                return;
            foreach (INotificationSubscription untypedSubscription in matchingSubsctiptions)
            {
                if (untypedSubscription == null)
                {
                    // TODO: Decide whether exception shuld be thrown when a null subscription is encountered in the matching collection
                }
                // TODO: Consider whether type-matching at this place can be ensured in advance.
                INotificationSubscription<TSender, TEventArgs> typedSubscription =
                    untypedSubscription as INotificationSubscription<TSender, TEventArgs>;
                if (typedSubscription == null)
                {
                    // TODO: Decide how to handle the situation where a subscription that does not match the anticipated type is encountered
                    // in the matching subscriptions collection. This wil depend on final design of notification type-matching rules and algorithms.
                }
                else 
                {
                    INotificationSubscriber<TSender, TEventArgs> subscriber = typedSubscription.Subscriber;
                    if (subscriber == null)
                    {
                        throw new InvalidOperationException("Subscription object does not contain the subscriber (null reference).");
                    }
                    bool notifySubscriber = true;
                    if (typedSubscription.Filter != null)
                    {
                        notifySubscriber = typedSubscription.Filter.Matches(sender, eventArgs);
                    }
                    if (notifySubscriber)
                    {
                        subscriber.HandleNotification(sender, eventArgs);
                    }
                }
            }
        }

        /// <inheritdoc/>
        public INotificationSubscription<TSender, TEventArgs> SubscribeToNotifications<TSender, TEventArgs>(
                NotificationHandler<TSender, TEventArgs> notificationHandler,
                NotificationFilterDelegate<TSender, TEventArgs> notificationFilterDelegate)
            where TSender : class
        {
            if (notificationHandler == null)
            {
                throw new ArgumentNullException(nameof(notificationHandler), "Notification handler is not specified, cannot create a subscription.");
            }
            INotificationSubscriber<TSender, TEventArgs> notificationHandlingProxy =
                new NotificationSubscriber<TSender, TEventArgs>(notificationHandler);
            INotificationFilter<TSender, TEventArgs> notificationFilteringProxy = null;
            if (notificationFilterDelegate != null)
            {
                notificationFilteringProxy = new NotificationFilter<TSender, TEventArgs>(notificationFilterDelegate);
            }
            var ret = SubscribeToNotifications(notificationHandlingProxy, notificationFilteringProxy);
            return ret;
        }

        /// <inheritdoc/>
        public INotificationSubscription<TSender, TEventArgs> SubscribeToNotifications<TSender, TEventArgs, TFilterData>(
                NotificationHandler <TSender, TEventArgs> notificationHandler,
                NotificationFilterWithDataDelegate<TSender, TEventArgs, TFilterData> notificationFilterDelegate,
                TFilterData filterData)
            where TSender : class 
            where TFilterData : class
        {
            if (notificationHandler == null)
            {
                throw new ArgumentNullException(nameof(notificationHandler), "Notification handler is not specified, cannot create a subscription.");
            }
            INotificationSubscriber<TSender, TEventArgs> notificationHandlingProxy = 
                new NotificationSubscriber<TSender, TEventArgs>(notificationHandler);
            INotificationFilterWithData<TSender, TEventArgs, TFilterData> notificationFilteringProxy = null;
            if (notificationFilterDelegate != null)
            {
                notificationFilteringProxy = new NotificationFilterWithData<TSender, TEventArgs, TFilterData>(notificationFilterDelegate, filterData);
            }
            var ret = SubscribeToNotifications(notificationHandlingProxy, notificationFilteringProxy);
            return ret;
        }

        /// <inheritdoc/>
        public virtual INotificationSubscription<TSender, TEventArgs> SubscribeToNotifications<TSender, TEventArgs>(
                INotificationSubscriber<TSender, TEventArgs> notificationHandlingObject,
                INotificationFilter<TSender, TEventArgs> notificationFilter
            )
            where TSender : class
        {
            if (notificationHandlingObject == null)
            {
                throw new ArgumentNullException(nameof(notificationHandlingObject), 
                    "Object to handle notifications is not specified (null reference), cannot create a subscription.");
            }
            // Create subscription object, returned to the caller in order to be able to unsubscribe:
            INotificationSubscription<TSender, TEventArgs> subscription
                = new NotificationSubscription<TSender, TEventArgs>(notificationHandlingObject, notificationFilter);
            TKey key = CreateKey<TSender, TEventArgs>();
            // Register subscription internally such that the current aggregator can use it to send (type-) matching notifications
            // to the subscriber (possibly after optional filtering, as subscription requires):
            AddSubscription(key, subscription);
            return subscription;
        }

        public INotificationSubscription<TSender, TEventArgs> SubscribeToNotifications<TSender, TEventArgs>(
        INotificationSubscriber<TSender, TEventArgs> notificationHandlingObject,
        NotificationFilterDelegate<TSender, TEventArgs> notificationFilterDelegate)
    where TSender : class
        {
            INotificationFilter<TSender, TEventArgs> filterObject = 
                new NotificationFilter<TSender, TEventArgs>(notificationFilterDelegate);
            return SubscribeToNotifications(notificationHandlingObject, filterObject);
        }



        /// <inheritdoc/>
        public virtual bool UnSubscribe(INotificationSubscription subscription)
        {
            if (subscription == null)
            {
                throw new ArgumentNullException(nameof(subscription), "Subscription not specified (null reference).");
            }
            lock (Lock)
            {
                TKey key = CreateKey(subscription.SenderType, subscription.EventArgsType);
                var matchingSubscriptions = GetMatchingSubscriptionListThreadUnsafe(key);
                if (matchingSubscriptions == null)
                {
                    // Remark: it may be reconsidered whether it is better to throw in this case or just return.
                    // throw new ArgumentException("There are no subscriptions matching the specified subscription object.");
                    return false;
                }
                if (matchingSubscriptions.Contains(subscription))
                {
                    matchingSubscriptions.Remove(subscription);
                    return true;
                }
            }
            return false;
        }

        /// <summary>Returns the list of subscriptions contained under the specific key.
        /// <para>The returned list is NOT thread safe, i.e., several threads that obtain this list can not safely perform operations
        /// on it, and need to lock the list by <see cref="Lock"/> property.</para></summary>
        /// <param name="key">Key to access list of subscriptions of the same type (i.e., subscriptions that have the
        /// same parameter type of the generic <see cref="NotificationFilter{TSender, TEventArgs, TFilterData}"/> delegate).</param>
        /// <returns>List of subscriptions matchig the current key, which is a live part of the supporting structure storing
        /// subscriptions and is NOT thread safe.</returns>
        protected List<INotificationSubscription> GetMatchingSubscriptionListThreadUnsafe(TKey key)
        {
            if (Subscriptions.ContainsKey(key))
            {
                return Subscriptions[key];
            }
            else
            {
                return null;
            }
        }


        /// <summary>Returns the read-only array copy of subscriptions registered under the specific key.
        /// <para>The returned array is thread safe, i.e., several threads that obtain this array can safely perform access operations
        /// on its members. The operation itself is also thread safe.</para></summary>
        /// <param name="key">Key to access list of subscriptions of the same type (i.e., subscriptions that have the
        /// same parameter type of the generic <see cref="NotificationFilter{TSender, TEventArgs, TFilterData}"/> delegate).</param>
        /// <returns>A current (up-to-date) array copy of subscriptions matchig the specified key, copied from the supporting structure storing
        /// subscriptions in a thread-safe way.</returns>
        protected INotificationSubscription[] GetMatchingSubscriptionsCollectionCopy(TKey key)
        {
            lock (Lock)
            {
                if (Subscriptions.ContainsKey(key))  
                {
                    return Subscriptions[key].ToArray();
                }
                return null;
            }
        }


        /// <summary>Adds subscription to the list of subscriptions accessible via the specified key. The same 
        /// <paramref name="subscription"/> is added only once.
        /// <para>The operation is thread safe.</para></summary>
        /// <param name="key">The key to be used to access the list of subscriptions registered at this key.</param>
        /// <param name="subscription">Subscription to be added to the list of subscriptions under the specified key.</param>
        protected virtual void AddSubscription(TKey key, INotificationSubscription subscription)
        {
            lock (Lock)
            {
                List<INotificationSubscription> typeSubscriptionList = GetMatchingSubscriptionListThreadUnsafe(key);
                if (typeSubscriptionList == null)
                {
                    typeSubscriptionList = new List<INotificationSubscription>();
                    Subscriptions[key] = typeSubscriptionList;
                }
                if (!typeSubscriptionList.Contains(subscription))
                {
                    typeSubscriptionList.Add(subscription);
                }
            }
        }


        protected abstract TKey CreateKey(Type senderType, Type eventArgsType);

        protected TKey CreateKey<TSender, TEventArgs>()
            where TSender : class
        {
            return CreateKey(typeof(TSender), typeof(TEventArgs));
        }

        protected TKey CreateKeyNofiltered<TEventArgs>()
        {
            return CreateKey<object, TEventArgs>();
        }

        protected virtual INotificationSubscription<TSender, TEventArgs, TFilterData> CreateSubscription<TSender, TEventArgs, TFilterData>(
                INotificationSubscriber<TSender, TEventArgs> subscriber, 
                INotificationFilterWithData<TSender, TEventArgs, TFilterData> filter)
            where TSender : class where TFilterData : class
        {
            return new NotificationSubscription<TSender, TEventArgs, TFilterData>(subscriber, filter);
        }

        protected virtual INotificationSubscriber<TSender, TEventArgs> CreateSubscriberFromDelegate<TSender, TEventArgs>(
                NotificationHandler<TSender, TEventArgs> notificationHandler)
            where TSender : class 
        {
            return new NotificationSubscriber<TSender, TEventArgs>(notificationHandler);
        }

        protected virtual INotificationFilterWithData<TSender, TEventArgs, TFilterData> CreateFilterFromDelegate<TSender, TEventArgs, TFilterData>(
                NotificationFilterWithDataDelegate<TSender, TEventArgs, TFilterData> filterDelegate, TFilterData filterData)
            where TSender : class
            where TFilterData: class
        {
            return new NotificationFilterWithData<TSender, TEventArgs, TFilterData>(filterDelegate, filterData);
        }

    } // EventAggregatorGenericBase<TKey>




    /// <summary>Class used as key in generic event aggregators instead of <see cref="ValueTuple{Type, Type, Type}"/> when
    /// this type is not available (e.g. in .NET Framework versions earlier than 7.2).
    /// <para>If this type is used as key, the  <see cref="IEqualityComparer{EventTypeKey}"/> object must be passed to dictionary
    /// constructor as parameter (you can use <see cref="EventTypeKeyEqualityComparer"/>).</para></summary>
    public class EventTypeKey 
    {
        
        public Type Key1_TSender { get; protected set; }

        public Type Key2_TEventArgs { get; protected set; }

        //private Type Key3_TFilterData;

        public EventTypeKey(Type k1_sender, Type k2_args) 
        { Key1_TSender = k1_sender; Key2_TEventArgs = k2_args; }

    }


    /// <summary>Equality comparer to be used in dictionaries that use <see cref="EventTypeKey"/> as dictionary key.</summary>
    public class EventTypeKeyEqualityComparer : IEqualityComparer<EventTypeKey>
    {

        public bool Equals(EventTypeKey k1, EventTypeKey k2)
        {
            if (k1 == null && k2 == null)
                return true;
            else if (k1 == null || k2 == null)
                return false;
            else
                return k1.Key1_TSender.Equals(k2.Key1_TSender) && k1.Key2_TEventArgs.Equals(k2.Key2_TEventArgs); // && k1.Key3_TFilterData.Equals(k2.Key3_TFilterData);
        }

        public int GetHashCode(EventTypeKey key)
        {
            int hashcode = 17;
            hashcode = unchecked(hashcode * 314159 + (key.Key1_TSender == null ? 3 : key.Key1_TSender.GetHashCode()));
            hashcode = unchecked(hashcode * 314159 + (key.Key2_TEventArgs == null ? 5 : key.Key2_TEventArgs.GetHashCode()));
            //hashcode = unchecked(hashcode * 314159 + (key.Key3_TFilterData == null ? 7 : key.Key3_TFilterData.GetHashCode()));
            return hashcode;
        }

    }



}
