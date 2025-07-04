// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Text;

namespace IG.Lib.Events
{




    public interface IEventAggregatorGeneric
    {

        /// <summary>Publishes a notification (event) of the given type (deterrmined by type parameters).
        /// <para>When this method is caled, the current event aggregator will find all type-matching subscriptions in order to identify
        /// the subscribers potentially interested in the event / notification. It will then use the identified subscription objects 
        /// in order to eventually forward notification to interested subscribers, eventually using the optional filter objects provided 
        /// on subscriptions to decide whether notfications should actually be sent to teh specific subscribers. Notifications are sent 
        /// by invoking the handler method on the <see cref="INotificationSubscriber{TSender, TEventArgs}"/> objects found on  the corresponding
        /// subscription objects.</para></summary>
        /// <typeparam name="TSender">Type of the sender parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
        /// that will handle the subscribed notifications (events) when they are sent by the current event aggregator. 
        /// Also used by the filter, see <typeparamref name="TFilterData"/>.</typeparam>
        /// /*
        /// <typeparam name="TEventArgs">Type of the event / notification data parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
        /// that will handle the subscribed notifications (events) when they are sent by the current event aggregator.
        /// Also used by the filter, see <typeparamref name="TFilterData"/>.</typeparam>
        /// */
        /// <typeparam name="TFilterData">Type of the filter data parameter in <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}.Matches(TSender, TEventArgs, TFilterData)"/>
        /// that will optinally (when <paramref name="notificationFilter"/> is defined) evaluate the filtering condition such that the current event aggregator
        /// can decide whether a specific (type-matching) notification should actually be passed to the subscriber.</typeparam>
        /// <param name="sender">Object that originated the notification (usually containing the caller of this method).</param>
        /// <param name="eventArgs">Data parameter of the notification, used to pass all the necessary data to the subscriber  to be able to
        /// handle the notification / event.</param>
        /// <param name="filterData">Contains optional additional information used by the filter (when provided by the subscriber / existing on the 
        /// subscription object) such that the filter can decide whether the current notification should be passed on to the specific subscriber or not.</param>
        void PublishNotification<TSender, TEventArgs>(TSender sender, TEventArgs eventArgs)
            where TSender : class;


        /// <summary>Creates and registers a subscription to receive the appropriate (type-matching) notifications (by invoking the specified 
        /// <paramref name="notificationHandler"/>, possibly after filtering notifications by <paramref name="notificationFilterDelegate"/>), 
        /// and returns the subscription object to the caller (subscriber) such that the caller can use it to unsubscribe later.
        /// <para>This method just creates the appropriate proxy objects that wrap the provided delegates and calls the
        ///   <see cref="SubscribeToNotifications{TSender, TEventArgs, TFilterData}(INotificationSubscriber{TSender, TEventArgs}, INotificationFilter{TSender, TEventArgs, TFilterData})"/>
        /// to do the job.</para>
        /// </summary>
        /// <typeparam name="TSender">See the corresponding description in the referenced method documentation.</typeparam>
        /// <typeparam name="TEventArgs">See the corresponding description in the referenced method documentation.</typeparam>
        /// <typeparam name="TFilterData">See the corresponding description in the referenced method documentation.</typeparam>
        /// <param name="notificationHandler">Handler to be called by the current event aggregator on matching events.</param>
        /// <param name="notificationFilterDelegate">Optional filter delegate to be called by the current event aggregator in order to determine
        /// whether the matching notification / event should actually be passed to the subscriber.</param>
        /// <returns></returns>
        /// <seealso cref="SubscribeToNotifications{TSender, TEventArgs, TFilterData}(INotificationSubscriber{TSender, TEventArgs}, INotificationFilter{TSender, TEventArgs, TFilterData})"/>
        INotificationSubscription<TSender, TEventArgs> SubscribeToNotifications<TSender, TEventArgs>(
                NotificationHandler<TSender, TEventArgs> notificationHandler,
                NotificationFilterDelegate<TSender, TEventArgs> notificationFilterDelegate = null)
            where TSender : class;

        /// <summary>Creates and registers a subscription to receive the appropriate (type-matching) notifications (by invoking the specified 
        /// <paramref name="notificationHandler"/>, possibly after filtering notifications by <paramref name="notificationFilterWithDataDelegate"/>), 
        /// and returns the subscription object to the caller (subscriber) such that the caller can use it to unsubscribe later.
        /// <para>This method just creates the appropriate proxy objects that wrap the provided delegates and calls the
        ///   <see cref="SubscribeToNotifications{TSender, TEventArgs, TFilterData}(INotificationSubscriber{TSender, TEventArgs}, INotificationFilter{TSender, TEventArgs, TFilterData})"/>
        /// to do the job.</para>
        /// </summary>
        /// <typeparam name="TSender">See the corresponding description in the referenced method documentation.</typeparam>
        /// <typeparam name="TEventArgs">See the corresponding description in the referenced method documentation.</typeparam>
        /// <typeparam name="TFilterData">See the corresponding description in the referenced method documentation.</typeparam>
        /// <param name="notificationHandler">Handler to be called by the current event aggregator on matching events.</param>
        /// <param name="notificationFilterWithDataDelegate">Filter delegate to be called by the current event aggregator in order to determine
        /// whether the matching notification / event should actually be passed to the subscriber.</param>
        /// <param name="filterData">Filter data that is passed to <paramref name="notificationFilterWithDataDelegate"/> as
        /// data parameter where evaluating the filtering condition.</param>
        /// <returns></returns>
        /// <seealso cref="SubscribeToNotifications{TSender, TEventArgs, TFilterData}(INotificationSubscriber{TSender, TEventArgs}, INotificationFilter{TSender, TEventArgs, TFilterData})"/>
        INotificationSubscription<TSender, TEventArgs> SubscribeToNotifications<TSender, TEventArgs, TFilterData>(
                NotificationHandler<TSender, TEventArgs> notificationHandler,
                NotificationFilterWithDataDelegate<TSender, TEventArgs, TFilterData> notificationFilterWithDataDelegate,
                TFilterData filterData)
            where TSender : class
            where TFilterData : class;

        /// <summary>Creates and registers a subscription to receive the appropriate (type-matching) notifications (by invoking the handler on 
        /// <paramref name="notificationFilter"/>, possibly after filtering notifications by <paramref name="notificationFilter"/>), and returns
        /// the subscription object to the caller (subscriber) such that the caller can use it to unsubscribe later.
        /// </summary>
        /// <typeparam name="TSender">Type of the sender parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
        /// that will handle the subscribed notifications (events) when they are sent by the current event aggregator. 
        /// Also used by the filter, see <typeparamref name="TFilterData"/>.</typeparam>
        /// <typeparam name="TEventArgs">Type of the event / notification data parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
        /// that will handle the subscribed notifications (events) when they are sent by the current event aggregator.
        /// Also used by the filter, see <typeparamref name="TFilterData"/>.</typeparam>
        /// <typeparam name="TFilterData">Type of the filter data parameter in <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}.Matches(TSender, TEventArgs, TFilterData)"/>
        /// that will optinally (when <paramref name="notificationFilter"/> is defined) evaluate the filtering condition such that the current event aggregator
        /// can decide whether a specific (type-matching) notification should actually be passed to the subscriber.</typeparam>
        /// <param name="notificationHandlingObject">Object that contains the handler for the notification, invoked by the aggregattor when a matching notification
        /// occurs on the source (input) side.</param>
        /// <param name="notificationFilter">Optional filter object that can be applied (by calling its <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}.
        /// Matches(TSender, TEventArgs, TFilterData)"/> method) by the aggregator in otder to decide whether the specific type-matching notification should 
        /// actually be passed to the subscriber. </param>
        /// <returns>Subscription object that can be used to unsubscribe certain subscription.</returns>
        INotificationSubscription<TSender, TEventArgs> SubscribeToNotifications<TSender, TEventArgs>(
                INotificationSubscriber<TSender, TEventArgs> notificationHandlingObject,
                INotificationFilter<TSender, TEventArgs> notificationFilter = null
            )
            where TSender : class;

        /// <summary>Creates and registers a subscription to receive the appropriate (type-matching) notifications (by invoking the specified 
        /// <paramref name="notificationHandler"/>, possibly after filtering notifications by <paramref name="notificationFilterDelegate"/>), 
        /// and returns the subscription object to the caller (subscriber) such that the caller can use it to unsubscribe later.
        /// <para>This method just creates the appropriate proxy objects that wrap the provided delegates and calls the
        ///   <see cref="SubscribeToNotifications{TSender, TEventArgs, TFilterData}(INotificationSubscriber{TSender, TEventArgs}, INotificationFilter{TSender, TEventArgs, TFilterData})"/>
        /// to do the job.</para>
        /// </summary>
        /// <typeparam name="TSender">See the corresponding description in the referenced method documentation.</typeparam>
        /// <typeparam name="TEventArgs">See the corresponding description in the referenced method documentation.</typeparam>
        /// <typeparam name="TFilterData">See the corresponding description in the referenced method documentation.</typeparam>
        /// <param name="notificationHandlingObject">Object that contains the handler for the notification, invoked by the aggregattor when a matching notification
        /// occurs on the source (input) side.</param>
        /// <param name="notificationFilterDelegate">Optional filter delegate to be called by the current event aggregator in order to determine
        /// whether the matching notification / event should actually be passed to the subscriber.</param>
        /// <returns></returns>
        /// <seealso cref="SubscribeToNotifications{TSender, TEventArgs, TFilterData}(INotificationSubscriber{TSender, TEventArgs}, INotificationFilter{TSender, TEventArgs, TFilterData})"/>
        INotificationSubscription<TSender, TEventArgs> SubscribeToNotifications<TSender, TEventArgs>(
                INotificationSubscriber<TSender, TEventArgs> notificationHandlingObject,
                NotificationFilterDelegate<TSender, TEventArgs> notificationFilterDelegate)
            where TSender : class;




        /// <summary>Unsubscribes the subscription defined by <paramref name="subscription"/>, and returns true if
        /// the operaiton was successful, and false if not.</summary>
        /// <param name="subscription">The subscription object that represents and contains information on the 
        /// subscription that needs to be unsubscribed. For the operation to be successful, subscription needs to
        /// be the object created and returned by the current event aggregator. A copy of such an object could
        /// not be located because the process is based on subscription object reference, rather than its value.</param>
        /// <returns>True if the subscription specified by <paramref name="subscription"/> was found and removed,
        /// false if not (e.g. subscription was not found, possibly already unsubscribed, or such a subscription
        /// was never returned by the current event aggregator.)</returns>
        /// <remarks>For this operation to succeed, the <paramref name="subscription"/> parameter must be the same
        /// object (reference equality rather than value equality) that was returned by one of the subscription 
        /// methods of the current event aggregator 
        /// (e.g. <see cref="SubscribeToNotifications{TSender, TEventArgs, TFilterData}(NotificationHandler{TSender, TEventArgs}, NotificationFilterWithDataDelegate{TSender, TEventArgs, TFilterData}, TFilterData)"/>,
        /// <see cref="SubscribeToNotifications{TSender, TEventArgs}(INotificationSubscriber{TSender, TEventArgs}, INotificationFilter{TSender, TEventArgs})"/>,
        /// <see cref="SubscribeToNotifications{TSender, TEventArgs}(NotificationHandler{TSender, TEventArgs}, NotificationFilterDelegate{TSender, TEventArgs})"/>).</remarks>
        bool UnSubscribe(INotificationSubscription subscription);

    }

}
