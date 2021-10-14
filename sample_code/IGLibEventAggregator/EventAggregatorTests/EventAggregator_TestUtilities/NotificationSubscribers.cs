// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IG.Lib.Events;
using IG.Lib;

namespace IG.Tests.Events
{


    /// <summary>Implemented by test notification subscribers to keep track of arrived events.</summary>
    public abstract class TestSubscriberBase : GloballyIdentifiableTestUtil,
        IGloballyIdentifiable
    {

        /// <summary>List of notifications received by now.</summary>
        protected List<TestEventInfo> ReceivedNotifiactions { get; } = new List<TestEventInfo>();

        /// <summary>Adds notification information <paramref name="newInfo"/> to the list of received notifications.</summary>
        /// <param name="newInfo"></param>
        protected void AddNotificationData(TestEventInfo newInfo)
        {
            lock (Lock) { ReceivedNotifiactions.Add(newInfo); }
        }


        /// <summary>Returns information on the stored notification at the specified index in the list of stored notifications.</summary>
        /// <param name="index">Index of stored notification in the list. If negative number then notifications are counted backwards from the 
        /// end of the list, such that index -1 gives the last notification received.</param>
        /// <returns>Returns teh notification information at the specified index in the list, or null iif index is out of range.</returns>
        public TestEventInfo GetNotification(int index)
        {
            if (index < 0)
                index = NumNotifications + index;
            if (index < 0 || index >= NumNotifications)
                return null;
            return ReceivedNotifiactions[index];
        }

        /// <summary>Total number of notifications received by the current test subscriber.</summary>
        public int NumNotifications { get { return ReceivedNotifiactions.Count; } }

        /// <summary>Whether the current object has received the notification with the specified event data ID (i.e.,
        /// event data with specific <see cref=IGloballyIdentifiable.ObjectId"/>).</summary>
        /// <param name="eventDataObjectId">Object ID (<see cref=IGloballyIdentifiable.ObjectId"/> property) to be matched.</param>
        /// <returns>True if notificatino with the specified <see cref=IGloballyIdentifiable.ObjectId"/> has been received by the 
        /// current subscriber object, false if not.</returns>
        public bool ContainsNotificationByDataId(int dataId)
        {
            return (ContainsNotification(
                info => info.DataId == dataId));
        }

        /// <summary>Whether the current object has received the notification matching the criteria specified by <see cref="criterion"/>.</summary>
        /// <param name="criterion">Function delegate that identifies matching event / notification information; must return true for
        /// notification information that matches the intended criteria, and false otherwise.</param>
        public bool ContainsNotification(Func<TestEventInfo, bool> criterion)
        {
            lock(Lock)
            {
                int count = ReceivedNotifiactions.Count;
                for (int i = count - 1; i>=0; --i)
                {
                    TestEventInfo eventInfo = ReceivedNotifiactions[i];
                    if (eventInfo != null)
                    {
                        if (criterion(eventInfo))
                            return true;
                    }
                }
                return false;
            }
        }

        /// <summary>Finds and returns notification information, received and stored by the current object, which has the 
        /// specific event data object with the specified object ID (<see cref="IGloballyIdentifiable.ObjectId"/>, accessed
        /// via <see cref="TestEventInfo.DataId"/> property).</summary>
        /// <param name="eventDataId">The object ID (<see cref="IGloballyIdentifiable.ObjectId"/>) of event data of notification we look for.</param>
        /// <returns>Information on the searched event / notification, or null in case that no information on matching event could be found.</returns>
        public TestEventInfo FindNotificationByDataId(int eventDataId)
        {
            return FindNotification((info) => info.DataId == eventDataId);
        }

        /// <summary>Finds and returns notification information, received and stored by the current object, which satispies the 
        /// specific criteria expressed by the <paramref name="criterion"/> function delegate. 
        /// <para></para>If there are more matches then the information on the last matching event is returned. If there are no
        /// matches then null is returned.</para></summary>
        /// <param name="criterion">Function that identifies matching event information, must return true in case of match
        /// and false otherwise.</param>
        public TestEventInfo FindNotification(Func<TestEventInfo, bool> criterion)
        {
            lock (Lock)
            {
                int count = ReceivedNotifiactions.Count;
                for (int i = count - 1; i >= 0; --i)
                {
                    TestEventInfo eventInfo = ReceivedNotifiactions[i];
                    if (eventInfo != null)
                    {
                        if (criterion(eventInfo))
                            return eventInfo;
                    }
                }
                return null;
            }
        }

    }


    /// <summary>Test class that can be used used to publish notifications / events of type (<typeparamref name="TSender"/>, <typeparamref name="TEventArgs"/>),
    /// or of type (<see cref="object"/>, <typeparamref name="TEventArgs"/>), or of arbitrary custom types.</summary>
    /// <typeparam name="TSender">Sender type for default method <see cref="Publish(TSender, TEventArgs)"/> that publishes notifications.</typeparam>
    /// <typeparam name="TEventArgs">Event data type for methods <see cref="Publish(TSender, TEventArgs)"/> and <see cref="PublishPlain(object, TEventArgs)"/>
    /// that publish norifications of class-specified types.</typeparam>
    /// <seealso cref="ITestPublisher{TSender, TEventArgs}"/>
    public class TestSubscriber<TSender, TEventArgs> : TestSubscriberBase, 
            INotificationSubscriber<TSender, TEventArgs>,
            IGloballyIdentifiable
        where TSender : class
    {

        public TestSubscriber()
        {
        }

        public void HandleNotification(TSender sender, TEventArgs eventArgs)
        {
            CustomTypeHandleNotification<TSender, TEventArgs>(sender, eventArgs);
        }

        ///<inheritdoc/>
        public void HandleNotificationPlain(object sender, TEventArgs eventArgs)
        {
            CustomTypeHandleNotification<object, TEventArgs>(sender, eventArgs);
        }

        public virtual void CustomTypeHandleNotification<TSenderCustSig, TEventArgsCustSig>(TSenderCustSig sender, TEventArgsCustSig eventArgs)
            where TSenderCustSig : class
        {
            lock (Lock)
            {
                if (ConsoleOutput)
                {
                    Console.WriteLine($"Handling event from {ToString()}: sender = {sender}(T:{typeof(TSenderCustSig).Name}); data = {eventArgs}(T:{typeof(TEventArgsCustSig).Name}).");
                }
                // Note down the received event / notification for querying:
                AddNotificationData(new TestEventInfo(sender, eventArgs));
            }
        }

        public override string ToString()
        {
            return $"{{{GetType().Name}: OID = {ObjectId}}}";
        }

    }


}
