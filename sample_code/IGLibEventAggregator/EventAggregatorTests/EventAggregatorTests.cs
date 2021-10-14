// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

//using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics;
using NUnit.Framework;
using IG.Lib.Events;

namespace IG.Tests.Events
{

    /// <summary>Tests for <see cref="EventAggregatorGeneric"/> class.</summary>
    /// <remarks>In these tests, assertions are sometimes made also on preconditions, not only on things that
    /// individual test verifies. In such situations, assertion messages should start with "PRECOND:". This
    /// facilitates identification of root causes of failed tests. If several tests fail for a common bug, one 
    /// can quickly identify the tests whose subject can indicate the root cause (i.e., the one whose assertions
    /// do not fail on preconditions but rather the main assertion(s) fail).</remarks>
    //[TestClass] // MSTests attribute
    [TestFixture]
    public class EventAggregatorTests
    {


        ////[TestMethod]
        [Test]
        public void Aaa_Dummy()
        { }



        // [TestMethod]  // MSTest attribute
        [Test]
        public void Subscription__Subscribed_SubscribedInterfaceObject_Receives_Notification()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, WindowData> windowEventPublisher = new TestPublisher<TestPublisher, WindowData>(eventAggregator);
            TestSubscriber<TestPublisher, WindowData> windowEventSubscriber = new TestSubscriber<TestPublisher, WindowData>();
            // subscribe windowEventSubscriber's interface INotificationSubscriber<TestPublisher, WindowData>:
            var subscription = eventAggregator.SubscribeToNotifications<TestPublisher, WindowData>(windowEventSubscriber);
            Assert.IsNotNull(subscription, "PRECOND: Subscription did not succeed.");
            int numreceivedInitial = windowEventSubscriber.NumNotifications;
            // Send notification via windowEventPublisher:
            WindowData eventData = new WindowData("Notepad", 48759656, "Notepad");
            windowEventPublisher.Publish(windowEventPublisher, eventData);
            int numreceived = windowEventSubscriber.NumNotifications;  // current number of received notifications
            Assert.AreEqual(1, numreceived - numreceivedInitial);
            TestEventInfo lastEventInfo = windowEventSubscriber.GetNotification(-1);
            // Check that the last received notification (event handler invocation) received expected data:
            TestPublisher receivedSender = lastEventInfo.SenderObject as TestPublisher;
            Assert.IsNotNull(receivedSender);
            Assert.AreEqual(windowEventPublisher.ObjectId, receivedSender.ObjectId);
            WindowData receivedEventData = lastEventInfo.EventArgsObject as WindowData;
            Assert.IsNotNull(receivedEventData);
            Assert.AreEqual(eventData, receivedEventData);
        }

        [Test]
        public void Subscription__Subscribed_SubscribedInterfaceObject_Without_Explicit_Types_Stated_Receives_Notification()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, WindowData> windowEventPublisher = new TestPublisher<TestPublisher, WindowData>(eventAggregator);
            TestSubscriber<TestPublisher, WindowData> windowEventSubscriber = new TestSubscriber<TestPublisher, WindowData>();
            // subscribe windowEventSubscriber's interface INotificationSubscriber<TestPublisher, WindowData>:
            var subscription = eventAggregator.SubscribeToNotifications(windowEventSubscriber);
            Assert.IsNotNull(subscription, "PRECOND: Subscription did not succeed.");
            int numreceivedInitial = windowEventSubscriber.NumNotifications;
            // Send notification via windowEventPublisher:
            WindowData eventData = new WindowData("Notepad", 48759656, "Notepad");
            windowEventPublisher.Publish(windowEventPublisher, eventData);
            int numreceived = windowEventSubscriber.NumNotifications;  // current number of received notifications
            Assert.AreEqual(1, numreceived - numreceivedInitial);
            TestEventInfo lastEventInfo = windowEventSubscriber.GetNotification(-1);
            // Check that the last received notification (event handler invocation) received expected data:
            TestPublisher receivedSender = lastEventInfo.SenderObject as TestPublisher;
            Assert.IsNotNull(receivedSender);
            Assert.AreEqual(windowEventPublisher.ObjectId, receivedSender.ObjectId);
            WindowData receivedEventData = lastEventInfo.EventArgsObject as WindowData;
            Assert.IsNotNull(receivedEventData);
            Assert.AreEqual(eventData, receivedEventData);
        }

        [Test]
        public void Subscription__Subscribed_Delegate_EventHandler_Receives_Notification()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, WindowData> windowEventPublisher = new TestPublisher<TestPublisher, WindowData>(eventAggregator);
            TestSubscriber<TestPublisher, WindowData> windowEventSubscriber = new TestSubscriber<TestPublisher, WindowData>();
            // subscribe windowEventSubscriber's handler (subscription via delegate, instead of interface):
            var subscription = eventAggregator.SubscribeToNotifications<TestPublisher, WindowData>(windowEventSubscriber.HandleNotification, null);
            Assert.IsNotNull(subscription, "PRECOND: Subscription did not succeed.");
            int numreceivedInitial = windowEventSubscriber.NumNotifications;
            // Send notification via windowEventPublisher:
            WindowData eventData = new WindowData("Notepad", 48759656, "Notepad");
            windowEventPublisher.Publish(windowEventPublisher, eventData);
            int numreceived = windowEventSubscriber.NumNotifications;  // current number of received notifications
            Assert.AreEqual(1, numreceived - numreceivedInitial);
            TestEventInfo lastEventInfo = windowEventSubscriber.GetNotification(-1);
            // Check that the last received notification (event handler invocation) received expected data:
            TestPublisher receivedSender = lastEventInfo.SenderObject as TestPublisher;
            Assert.IsNotNull(receivedSender);
            Assert.AreEqual(windowEventPublisher.ObjectId, receivedSender.ObjectId);
            WindowData receivedEventData = lastEventInfo.EventArgsObject as WindowData;
            Assert.IsNotNull(receivedEventData);
            Assert.AreEqual(eventData, receivedEventData);
        }


        [Test]
        public void Subscription__InterfaceSubscribed_InterfaceObject_Only_Exact_Type_Matched_Receives_Notification()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, CityDataExtended> cityEventPublisher = new TestPublisher<TestPublisher, CityDataExtended>(eventAggregator);
            // Subscriber that exactly matches data types:
            TestSubscriber<TestPublisher, CityDataExtended> cityEventSubscriberExactDataType = new TestSubscriber<TestPublisher, CityDataExtended>();
            // Subscribe cityEventSubscriberDerivedDataType's interface INotificationSubscriber<TestPublisher, CityDataExtended>:
            var subscriptionExactDataType = eventAggregator.SubscribeToNotifications<TestPublisher, CityDataExtended>(
                cityEventSubscriberExactDataType);
            Assert.IsNotNull(subscriptionExactDataType, "PRECOND: Subscription did not succeed.");
            // Subscriber that does NOT have exact type matching (event data type is base type of exact type; this would work in argument 
            // passing but not in subscription / dispatch:
            TestSubscriber<TestPublisher, CityData> cityEventSubscriberBaseDataType = new TestSubscriber<TestPublisher, CityData>();
            // subscribe cityEventSubscriber's interface INotificationSubscriber<TestPublisher, CityData>:
            var subscriptionBaseDataType = eventAggregator.SubscribeToNotifications<TestPublisher, CityData>(cityEventSubscriberBaseDataType);
            Assert.IsNotNull(subscriptionBaseDataType, "PRECOND: Subscription did not succeed.");
            // Send notification via cityEventPublisher:
            CityDataExtended eventDataExactType = new CityDataExtended("Graz", 3000000, 8.4);
            cityEventPublisher.Publish(cityEventPublisher, eventDataExactType);
            // Subscriber with EXACT TYPE MATCH should reeceive notification:
            TestEventInfo lastEventInfoExactDataType = cityEventSubscriberExactDataType.GetNotification(-1);
            Assert.IsNotNull(lastEventInfoExactDataType);
            // Subscriber WITHOUT EXACT TYPE MATCH should NOT reeceive notification:
            TestEventInfo testEventInfoFromBaseTypeSubscriber = cityEventSubscriberBaseDataType.GetNotification(-1);
            Assert.IsNull(testEventInfoFromBaseTypeSubscriber);
        }


        [Test]
        public void Subscription_Unsubscribed_Delegate_EventHandler_Stops_Receiving_Notifications()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, WindowData> windowEventPublisher = new TestPublisher<TestPublisher, WindowData>(eventAggregator);
            TestSubscriber<TestPublisher, WindowData> windowEventSubscriber = new TestSubscriber<TestPublisher, WindowData>();
            // subscribe windowEventSubscriber's handler (subscription via delegate, instead of interface):
            var subscription = eventAggregator.SubscribeToNotifications<TestPublisher, WindowData>(windowEventSubscriber.HandleNotification, null);
            Assert.IsNotNull(subscription, "PRECOND: Subscription did not succeed.");
            int numreceivedInitial = windowEventSubscriber.NumNotifications;
            // Send notification via windowEventPublisher:
            WindowData eventData = new WindowData("Notepad", 48759656, "Notepad");
            windowEventPublisher.Publish(windowEventPublisher, eventData);
            int numreceived = windowEventSubscriber.NumNotifications;  // current number of received notifications
            //Assert.AreEqual(1, numreceived - numreceivedInitial);
            // Verify that the list of received notifications maintained contins the one witth the specific event:
            Assert.IsTrue(windowEventSubscriber.ContainsNotificationByDataId(eventData.ObjectId),
                "PRECOND: After publishing the appropriate notification, subscriber has not received it.");
            //// Verify that the last received notification (event handler invocation) received expected data:
            //TestEventInfo lastEventInfo = windowEventSubscriber.GetNotification(-1);
            //WindowData receivedEventData = lastEventInfo.EventArgsObject as WindowData;
            //Assert.IsNotNull(receivedEventData, "PRECOND: Notification not received.");
            //Assert.AreEqual(eventData, receivedEventData, "PRECOND: Notification not received properly.");
            // Use Subscription object to unsubscribe the delegate:
            bool successful = eventAggregator.UnSubscribe(subscription as INotificationSubscription);
            Assert.IsTrue(successful, "The unsubscribe operation failed, which is not expected.");
            // Send notification via windowEventPublisher:
            WindowData eventDataAfterUnsubscribe = new WindowData("WordPad", 8397592, "WordPad");
            windowEventPublisher.Publish(windowEventPublisher, eventData);
            // Verify that the number of received notifications did not increase:
            int numreceivedAfterUnsubscribe = windowEventSubscriber.NumNotifications;  // current number of received notifications
            Assert.AreEqual(numreceived, numreceivedAfterUnsubscribe);
            // Subscriber still contains information about the first notification received:
            Assert.IsTrue(windowEventSubscriber.ContainsNotificationByDataId(eventData.ObjectId),
                "PRECOND: After publishing the appropriate notification, subscriber has not received it.");
            // But it should not contain information about the second notification (identified by event data ID)
            // because it has unsubscribed from these notifications:
            Assert.IsFalse(windowEventSubscriber.ContainsNotificationByDataId(eventDataAfterUnsubscribe.ObjectId),
                "After unsubscribing, subscriber still received a notification sent after that.");
        }


        [Test]
        public void Dispatch__Subscribed_Object_Can_Receive_Notifications_From_Multiple_Publishers()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, WindowData> publisher1 = new TestPublisher<TestPublisher, WindowData>(eventAggregator);
            TestPublisher<TestPublisher, WindowData> publisher2 = new TestPublisher<TestPublisher, WindowData>(eventAggregator);
            TestSubscriber<TestPublisher, WindowData> subscriber = new TestSubscriber<TestPublisher, WindowData>();
            // subscribe subscriber's interface INotificationSubscriber<TestPublisher, WindowData>:
            var subscription = eventAggregator.SubscribeToNotifications<TestPublisher, WindowData>(subscriber);
            // Send a notification of matching sender & eventArgs types via publisher1:
            WindowData eventData1 = new WindowData("Notepad", 48759656, "Notepad");
            publisher1.Publish(publisher1, eventData1);
            // Send a notification of matching sender & eventArgs types via publisher2:
            WindowData eventData2 = new WindowData("Wordpad", 50794855, "Wordpad");
            publisher2.Publish(publisher2, eventData2);
            // Check that subscriber received both events:
            int numreceived = subscriber.NumNotifications;
            Assert.AreEqual(2, numreceived);
            // Since both notifications were synchronous, they should arrive in the same order as they were sent:
            TestEventInfo eventInfo1 = subscriber.GetNotification(0);
            WindowData receivedEventData1 = eventInfo1.EventArgsObject as WindowData;
            Assert.AreEqual(eventData1, receivedEventData1);
            TestEventInfo eventInfo2 = subscriber.GetNotification(1);
            WindowData receivedEventData2 = eventInfo2.EventArgsObject as WindowData;
            Assert.AreEqual(eventData2, receivedEventData2);
        }


        [Test]
        public void Dispatch__Multiple_Subscribed_Objects_Can_Receive_Same_Notifications()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, WindowData> publisher = new TestPublisher<TestPublisher, WindowData>(eventAggregator);
            TestSubscriber<TestPublisher, WindowData> subscriber1 = new TestSubscriber<TestPublisher, WindowData>();
            TestSubscriber<TestPublisher, WindowData> subscriber2 = new TestSubscriber<TestPublisher, WindowData>();
            // subscribe both subscribers to this type of events:
            var subscription1 = eventAggregator.SubscribeToNotifications<TestPublisher, WindowData>(subscriber1);
            var subscription2 = eventAggregator.SubscribeToNotifications<TestPublisher, WindowData>(subscriber2);
            // Send a notification of matching sender & eventArgs types via publisher:
            WindowData eventData = new WindowData("Notepad", 48759656, "Notepad");
            publisher.Publish(publisher, eventData);
            // Verify that both subscribers received the notification:
            int numreceived1 = subscriber1.NumNotifications;
            Assert.AreEqual(1, numreceived1);
            int numreceived2 = subscriber2.NumNotifications;
            Assert.AreEqual(1, numreceived2);
            // Also verify that the received notification data is the same for both subscribers (it was a single 
            // originating notification):
            TestEventInfo eventInfo1 = subscriber1.GetNotification(0);
            WindowData receivedEventData1 = eventInfo1.EventArgsObject as WindowData;
            TestEventInfo eventInfo2 = subscriber2.GetNotification(0);
            WindowData receivedEventData2 = eventInfo2.EventArgsObject as WindowData;
            Assert.AreEqual(eventData, receivedEventData1);
            Assert.AreEqual(eventData, receivedEventData2);
        }


        [Test]
        public void Filtering__Subscriber_Can_Define_Notification_Filter_Object_With_SubscriptionInterface()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, CityDataExtended> publisher = new TestPublisher<TestPublisher, CityDataExtended>(eventAggregator);
            TestSubscriber<TestPublisher, CityDataExtended> subscriber = new TestSubscriber<TestPublisher, CityDataExtended>();
            // Define a filter to define which (type-) matching notifications should be actually sent to this subscriber:
            CityFilterData filterData = new CityFilterData();
            filterData.MaxInhabitants = 1000000;
            // Allow notifications only for cities with less than a million inhabitants - defined by filterData:
            var filter = new CityFilterExtended<TestPublisher>(filterData); 
            // subscribe subscriber's interface method, with a FILTER OBJECT provided:
            var subscriptionWithFilterObject = eventAggregator.SubscribeToNotifications<TestPublisher, CityDataExtended>(
                subscriber, filter);
            Assert.IsNotNull(subscriptionWithFilterObject, "PRECOND: Subscription with filter object defined did not succeed.");
            // Define two notification data objects, one that is passed through by the filter and one that is not:
            CityDataExtended eventDataPassed = new CityDataExtended("Graz", 294630, 8.4);
            CityDataExtended eventDataFilteredOut = new CityDataExtended("Vienna", 2600000, 8.4);
            // Verify the precondition that filter is set up correctly - it lets through the first city (Graz) but not the second (Vienna)
            Assert.IsTrue(filter.Matches(publisher, eventDataPassed), 
                $"PRECOND: Filter was not set correctly: the first object is not let through while it should be.");
            Assert.IsFalse(filter.Matches(publisher, eventDataFilteredOut), 
                $"PRECOND: Filter was not set correctly: the second object is let through while it should not be.");
            // Publish notification that passes through the subscription's filter:
            publisher.Publish(publisher, eventDataPassed);
            // Publish notification that is filtered out by the subscription's filter:
            publisher.Publish(publisher, eventDataFilteredOut);
            // Verify that subscriber has received the published event / notification that passes through the filter: 
            Assert.IsTrue(subscriber.ContainsNotificationByDataId(eventDataPassed.ObjectId),
                "Subscriber has not received notification that should pass through the filter.");
            // Verify that subscriber has NOT received the published event / notification that is filtered out by the subscribed filter: 
            Assert.IsFalse(subscriber.ContainsNotificationByDataId(eventDataFilteredOut.ObjectId),
                "Subscriber has not received notification that should pass through the filter.");
        }



        [Test]
        public void Filtering__Subscriber_Can_Define_Notification_Filter_Delegate_With_HandlerDelegate()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, CityDataExtended> publisher = new TestPublisher<TestPublisher, CityDataExtended>(eventAggregator);
            TestSubscriber<TestPublisher, CityDataExtended> subscriber = new TestSubscriber<TestPublisher, CityDataExtended>();
            // Define a filter to define which (type-) matching notifications should be actually sent to this subscriber:
            CityFilterData filterData = new CityFilterData();
            filterData.MaxInhabitants = 1000000;
            // Allow notifications only for cities with less than a million inhabitants - defined by filterData:
            var filterObject = new CityFilterExtended<TestPublisher>(filterData);
            // Subscribe subscriber's HANDLER DELEGATE, with a FILTER DELEGATE provided:
            var subscriptionWithFilterDelegate = eventAggregator.SubscribeToNotifications<TestPublisher, CityDataExtended>(
                subscriber.HandleNotification, filterObject.Matches);
            Assert.IsNotNull(subscriptionWithFilterDelegate, "PRECOND: Subscription with filter object defined did not succeed.");
            // Define two notification data objects, one that is passed through by the filter and one that is not:
            CityDataExtended eventDataPassed = new CityDataExtended("Graz", 294630, 8.4);
            CityDataExtended eventDataFilteredOut = new CityDataExtended("Vienna", 2600000, 8.4);
            // Verify the precondition that filter is set up correctly - it lets through the first city (Graz) but not the second (Vienna)
            Assert.IsTrue(filterObject.Matches(publisher, eventDataPassed),
                $"PRECOND: Filter was not set correctly: the first object is not let through while it should be.");
            Assert.IsFalse(filterObject.Matches(publisher, eventDataFilteredOut),
                $"PRECOND: Filter was not set correctly: the second object is let through while it should not be.");
            // Publish notification that passes through the subscription's filter:
            publisher.Publish(publisher, eventDataPassed);
            // Publish notification that is filtered out by the subscription's filter:
            publisher.Publish(publisher, eventDataFilteredOut);
            // Verify that subscriber has received the published event / notification that passes through the filter: 
            Assert.IsTrue(subscriber.ContainsNotificationByDataId(eventDataPassed.ObjectId),
                "Subscriber has not received notification that should pass through the filter.");
            // Verify that subscriber has NOT received the published event / notification that is filtered out by the subscribed filter: 
            Assert.IsFalse(subscriber.ContainsNotificationByDataId(eventDataFilteredOut.ObjectId),
                "Subscriber has not received notification that should pass through the filter.");
        }



        [Test]
        public void Filtering__Subscriber_Can_Define_Notification_Filter_Lambda_With_HandlerDelegate()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, CityDataExtended> publisher = new TestPublisher<TestPublisher, CityDataExtended>(eventAggregator);
            TestSubscriber<TestPublisher, CityDataExtended> subscriber = new TestSubscriber<TestPublisher, CityDataExtended>();
            // Define a filter delegate to define which (type-) matching notifications should be actually sent to this subscriber:
            int maxInhabitants = 1000000;
            NotificationFilterDelegate<TestPublisher, CityDataExtended> filterDelegateViaLambda = (sender, data) =>
            {
                return data != null && data.Inhabitants < maxInhabitants;
            };
            // Subscribe subscriber's HANDLER DELEGATE, with a FILTER DELEGATE provided:
            var subscriptionWithFilterDelegate = eventAggregator.SubscribeToNotifications<TestPublisher, CityDataExtended>(
                subscriber.HandleNotification, 
                filterDelegateViaLambda
                // Note: lambda expression can also be defined directly in argument block like below, but then it can not be reused in verifications:
                //(sender, data) =>
                //{
                //    return data != null && data.Inhabitants < maxInhabitants;
                //}
                );
            Assert.IsNotNull(subscriptionWithFilterDelegate, "PRECOND: Subscription with filter object defined did not succeed.");
            // Define two notification data objects, one that is passed through by the filter and one that is not:
            CityDataExtended eventDataPassed = new CityDataExtended("Graz", 294630, 8.4);
            CityDataExtended eventDataFilteredOut = new CityDataExtended("Vienna", 2600000, 8.4);
            // Verify the precondition that filter is set up correctly - it lets through the first city (Graz) but not the second (Vienna)
            Assert.IsTrue(filterDelegateViaLambda(publisher, eventDataPassed),
                $"PRECOND: Filter was not set correctly: the first object is not let through while it should be.");
            Assert.IsFalse(filterDelegateViaLambda(publisher, eventDataFilteredOut),
                $"PRECOND: Filter was not set correctly: the second object is let through while it should not be.");
            // Publish notification that passes through the subscription's filter:
            publisher.Publish(publisher, eventDataPassed);
            // Publish notification that is filtered out by the subscription's filter:
            publisher.Publish(publisher, eventDataFilteredOut);
            // Verify that subscriber has received the published event / notification that passes through the filter: 
            Assert.IsTrue(subscriber.ContainsNotificationByDataId(eventDataPassed.ObjectId),
                "Subscriber has not received notification that should pass through the filter.");
            // Verify that subscriber has NOT received the published event / notification that is filtered out by the subscribed filter: 
            Assert.IsFalse(subscriber.ContainsNotificationByDataId(eventDataFilteredOut.ObjectId),
                "Subscriber has not received notification that should pass through the filter.");
        }


        [Test]
        public void Filtering__Subscriber_Can_Define_Notification_Filter_Lambda_With_SubscriptionInterface()
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, CityDataExtended> publisher = new TestPublisher<TestPublisher, CityDataExtended>(eventAggregator);
            TestSubscriber<TestPublisher, CityDataExtended> subscriber = new TestSubscriber<TestPublisher, CityDataExtended>();
            // Define a filter delegate to define which (type-) matching notifications should be actually sent to this subscriber:
            int maxInhabitants = 1000000;
            NotificationFilterDelegate<TestPublisher, CityDataExtended> filterDelegateViaLambda = (sender, data) =>
            {
                return data != null && data.Inhabitants < maxInhabitants;
            };
            // Subscribe subscriber's interface method, with a FILTER OBJECT provided:
            var subscriptionWithFilterObject = eventAggregator.SubscribeToNotifications<TestPublisher, CityDataExtended>(
                subscriber, filterDelegateViaLambda);
            Assert.IsNotNull(subscriptionWithFilterObject, "PRECOND: Subscription with filter object defined did not succeed.");
            // Define two notification data objects, one that is passed through by the filter and one that is not:
            CityDataExtended eventDataPassed = new CityDataExtended("Graz", 294630, 8.4);
            CityDataExtended eventDataFilteredOut = new CityDataExtended("Vienna", 2600000, 8.4);
            // Verify the precondition that filter is set up correctly - it lets through the first city (Graz) but not the second (Vienna)
            Assert.IsTrue(filterDelegateViaLambda(publisher, eventDataPassed),
                $"PRECOND: Filter was not set correctly: the first object is not let through while it should be.");
            Assert.IsFalse(filterDelegateViaLambda(publisher, eventDataFilteredOut),
                $"PRECOND: Filter was not set correctly: the second object is let through while it should not be.");
            // Publish notification that passes through the subscription's filter:
            publisher.Publish(publisher, eventDataPassed);
            // Publish notification that is filtered out by the subscription's filter:
            publisher.Publish(publisher, eventDataFilteredOut);
            // Verify that subscriber has received the published event / notification that passes through the filter: 
            Assert.IsTrue(subscriber.ContainsNotificationByDataId(eventDataPassed.ObjectId),
                "Subscriber has not received notification that should pass through the filter.");
            // Verify that subscriber has NOT received the published event / notification that is filtered out by the subscribed filter: 
            Assert.IsFalse(subscriber.ContainsNotificationByDataId(eventDataFilteredOut.ObjectId),
                "Subscriber has not received notification that should pass through the filter.");
        }


        [Test]
        public void Performance_Notifications_Are_Processed_With_Sufficient_Throughput()
        {
            Performance_Notifications_Are_Processed_With_Sufficient_Throughput(10000, 1.0e5, true);
            Performance_Notifications_Are_Processed_With_Sufficient_Throughput(100000, 1.0e5, true);
            Performance_Notifications_Are_Processed_With_Sufficient_Throughput(10000, 1.0e5, false);
            Performance_Notifications_Are_Processed_With_Sufficient_Throughput(100000, 1.0e5, false);
        }


        //[DataTestMethod]
        //[DataRow(10000, 1.0e5, true)]
        //[DataRow(100000, 1.0e5, true)]
        //[DataRow(10000, 1.0e5, false)]
        //[DataRow(100000, 1.0e5, false)]
        public void Performance_Notifications_Are_Processed_With_Sufficient_Throughput(int numNotifications, 
            double requiredPerSecond, bool alocateNewDataEachTime)
        {
            IEventAggregatorGeneric eventAggregator = new EventAggregatorGeneric();
            TestPublisher<TestPublisher, WindowData> windowEventPublisher = new TestPublisher<TestPublisher, WindowData>(eventAggregator);
            TestSubscriber<TestPublisher, WindowData> windowEventSubscriber = new TestSubscriber<TestPublisher, WindowData>();
            // subscribe windowEventSubscriber's interface INotificationSubscriber<TestPublisher, WindowData>:
            var subscription = eventAggregator.SubscribeToNotifications<TestPublisher, WindowData>(windowEventSubscriber);
            Assert.IsNotNull(subscription, "PRECOND: Subscription did not succeed.");
            int numreceivedInitial = windowEventSubscriber.NumNotifications;
            // Prevent condoleoutput from components:
            windowEventPublisher.ConsoleOutput = false;
            windowEventSubscriber.ConsoleOutput = false;
            // Prepare a single data object in advance:
            WindowData eventData = new WindowData("WordPad", 96046, "WordPad");
            // Start measuring time:
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();
            for (int i = 0; i < numNotifications; ++i)
            {
                // Send notification via windowEventPublisher:
                if (alocateNewDataEachTime)
                {
                    eventData = new WindowData("Notepad", 48759656, "Notepad");
                }
                    windowEventPublisher.Publish(windowEventPublisher, eventData);
            }
            stopWatch.Stop();
            double secondsElapsed = stopWatch.Elapsed.TotalSeconds;
            double notificationsPerSecond = (double)numNotifications / secondsElapsed;
            Console.WriteLine(Environment.NewLine + 
                $"Performance: {numNotifications} processed in {Math.Round(1000.0*secondsElapsed)/(double)1000}; "
                + $"notifications per second: {Math.Round(notificationsPerSecond)}"
                + Environment.NewLine);
            Assert.IsTrue(notificationsPerSecond > requiredPerSecond, "Throughput is smaller than expected.");
            // Verify that all notifications were received and processed by the subscriber:
            int numreceived = windowEventSubscriber.NumNotifications;  // current number of received notifications
            Assert.AreEqual(numNotifications, numreceived - numreceivedInitial);
        }


    }
}

