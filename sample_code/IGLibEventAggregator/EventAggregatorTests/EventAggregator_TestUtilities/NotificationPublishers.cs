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


    /// <summary>Implemented by classes that contain an event aggregator; acts more as a marker interface for various 
    /// test classes than having a real function.</summary>
    public interface IHasEventAggregator
    {

        /// <summary>Event aggregator used by the current object to publish notifications / events."/>.</summary>
        IEventAggregatorGeneric EventAggregator { get; }

    }


    /// <summary>Used by tests that involve <see cref="IEventAggregatorGeneric"/> to manually publish any type of notifications
    /// via the <see cref="ITestPublisher.EventAggregator"/> property.</summary>
    public interface ITestPublisher: IHasEventAggregator, IGloballyIdentifiable
    {

        ///// <summary>Event aggregator used by the current object to publish notifications / events."/>.</summary>
        //IEventAggregatorGeneric EventAggregator { get; }


        /// <summary>Publishes notification of custom type via the contained <see cref="IEventAggregatorGeneric"/> object.
        /// <para>This method may also used by other notification methods that implement type-specific interfaces.</para></summary>
        /// <typeparam name="TSenderCustSig">Custom sender type (provided by the caller, not a class' generic type).</typeparam>
        /// <typeparam name="TEventArgsCustSig">Custom event data type (provided by the caller, not a class' generic type).</typeparam>
        /// <param name="sender">Sender of notification.</param>
        /// <param name="eventArgs">Notification data.</param>
        void CustomTypePublish<TSenderCustSig, TEventArgsCustSig>(TSenderCustSig sender, TEventArgsCustSig eventArgs)
            where TSenderCustSig : class;

    }

    /// <summary>Used by tests that involve <see cref="IEventAggregatorGeneric"/> to manually publish the desired typed notifications.
    /// <para>Provides three methods for sending notifications / triggering events via the <see cref="IEventAggregatorGeneric"/> 
    /// object (available as the <see cref="ITestPublisher.EventAggregator"/> property:</para>
    /// <para><see cref="Publish(TSender, TEventArgs)"/> for publishing events whose parameter types are specified by the class' type parameters.</para>
    /// <para><see cref="Publish(object, TEventArgs)"/> for publishing events whose sender type is plain <see cref="object"/> and event data 
    /// type is specified by the class' type parameter <typeparamref name="TEventArgs"/>.</para>
    /// <para><see cref="CustomTypePublish{TSnd, Targs}(TSnd, Targs)"/> for publishing events of arbitrary types.</para>
    /// </summary>
    /// <typeparam name="TSender">Type of sender parameter of some publishing methods.</typeparam>
    /// <typeparam name="TEventArgs">Type of event data parameter of some publishing methods.</typeparam>
    public interface ITestPublisher<TSender, TEventArgs> :
            ITestPublisher, 
            IGloballyIdentifiable
        where TSender : class
    {

        /// <summary>Publishes notifications of the types specified by class' type parameters, <see cref="TSender"/> and <see cref="TEventArgs"/>.</summary>
        /// <param name="sender">Sender of the notification / originator of event.</param>
        /// <param name="eventArgs">Data of the notification / event.</param>
        void Publish(TSender sender, TEventArgs eventArgs);

        /// <summary>Publishes notifications where the <paramref name="sender"/> parameter is of the plain <see cref="object"/> type, and
        /// the <paramref name="eventArgs"/> parameter is of type specified by class type parameter <see cref="TEventArgs"/>.</summary>
        /// <param name="sender">Sender of the notification / originator of event.</param>
        /// <param name="eventArgs">Data of the notification / event.</param>
        void PublishPlain(object sender, TEventArgs eventArgs);
    }


    public abstract class TestPublisher : GloballyIdentifiableTestUtil,
        ITestPublisher,
        IHasEventAggregator,
        IGloballyIdentifiable
    {


        ///<inheritdoc/>
        public virtual IEventAggregatorGeneric EventAggregator { get; protected set; }

        /// <summary>Sets the event aggregator instance used by the current object for publishing notifications.</summary>
        /// <param name="eventAggregator">Event aggregator to be used.</param>
        public virtual void SetEventAggregator(IEventAggregatorGeneric eventAggregator)
        {
            lock (Lock)
            {
                EventAggregator = eventAggregator;
            }
        }


        ///<inheritdoc/>
        ///<remarks>Thread safe.</remarks>
        public virtual void CustomTypePublish<TSenderCustSig, TEventArgsCustSig>(TSenderCustSig sender, TEventArgsCustSig eventArgs)
            where TSenderCustSig : class
        {
            lock (Lock)
            {
                if (EventAggregator == null)
                {
                    throw new InvalidOperationException($"Event aggregator is not specified on the publisher: {this}");
                }
                if (ConsoleOutput)
                    Console.WriteLine($"Triggering custom event from {ToString()}: sender = {sender}(T:{typeof(TSenderCustSig).Name}); data = {eventArgs}(T:{typeof(TEventArgsCustSig).Name}).");
                {
                    if (ConsoleOutput)
                        Console.WriteLine("  ERROR: Event aggregator to publish the notification is not specified.");
                    EventAggregator.PublishNotification(sender, eventArgs);
                }
            }
        }

    }


    /// <summary>Test class that can be used used to publish notifications / events of type (<typeparamref name="TSender"/>, <typeparamref name="TEventArgs"/>),
    /// or of type (<see cref="object"/>, <typeparamref name="TEventArgs"/>), or of arbitrary custom types.</summary>
    /// <typeparam name="TSender">Sender type for default method <see cref="Publish(TSender, TEventArgs)"/> that publishes notifications.</typeparam>
    /// <typeparam name="TEventArgs">Event data type for methods <see cref="Publish(TSender, TEventArgs)"/> and <see cref="PublishPlain(object, TEventArgs)"/>
    /// that publish norifications of class-specified types.</typeparam>
    /// <seealso cref="ITestPublisher{TSender, TEventArgs}"/>
    public class TestPublisher<TSender, TEventArgs> : TestPublisher, 
            ITestPublisher<TSender, TEventArgs>, 
            ITestPublisher,
            IGloballyIdentifiable
        where TSender : class  //, ITestPublisher
    {

        public TestPublisher(IEventAggregatorGeneric eventAggregator)
        {
            EventAggregator = eventAggregator;
        }

        /// <inheritdoc/>
        /// <remarks>Delegates work to <see cref="CustomTypePublish{TSenderCustSig, TEventArgsCustSig}(TSenderCustSig, TEventArgsCustSig)"/>
        /// That should be thread safe.</remarks>
        public void Publish(TSender sender, TEventArgs eventArgs)
        {
            CustomTypePublish<TSender, TEventArgs>(sender, eventArgs);
        }

        /// <inheritdoc/>
        /// <remarks>Delegates work to <see cref="CustomTypePublish{TSenderCustSig, TEventArgsCustSig}(TSenderCustSig, TEventArgsCustSig)"/>
        /// That should be thread safe.</remarks>
        public void PublishPlain(object sender, TEventArgs eventArgs)
        {
            CustomTypePublish<object, TEventArgs>(sender, eventArgs);
        }

        /////<inheritdoc/>
        /////<remarks>Thread safe.</remarks>
        //public virtual void CustomTypePublish<TSenderCustSig, TEventArgsCustSig>(TSenderCustSig sender, TEventArgsCustSig eventArgs)
        //    where TSenderCustSig : class
        //{
        //    lock (Lock)
        //    {
        //        if (ConsoleOutput)
        //            Console.WriteLine($"Triggering custom event from {ToString()}: sender = {sender}(T:{typeof(TSenderCustSig).Name}); data = {eventArgs}(T:{typeof(TEventArgsCustSig).Name}).");
        //        if (EventAggregator == null)
        //        {
        //            if (ConsoleOutput)
        //                Console.WriteLine("  ERROR: Event aggregator to publish the notification is not specified.");
        //            EventAggregator.PublishNotification(sender, eventArgs);
        //        }
        //    }
        //}

        /// <inheritdoc/>
        /// <remarks>Thread safe.</remarks>
        public override string ToString()
        {
            lock (Lock)
            {
                return $"{{{GetType().Name}: OID = {ObjectId}}}";
            }
        }

    }


    /// <summary>Test class that can be used used to publish notifications / events of type (<typeparamref name="TSender"/>, <typeparamref name="TEventArgs"/>),
    /// or of type (<see cref="object"/>, <typeparamref name="TEventArgs"/>), or of arbitrary custom types.</summary>
    /// <typeparam name="TSender">Sender type for default method <see cref="Publish(TSender, TEventArgs)"/> that publishes notifications.</typeparam>
    /// <typeparam name="TEventArgs">Event data type for methods <see cref="Publish(TSender, TEventArgs)"/> and <see cref="PublishPlain(object, TEventArgs)"/>
    /// that publish norifications of class-specified types.</typeparam>
    /// <seealso cref="ITestPublisher{TSender, TEventArgs}"/>
    public class TestPublisher<TSender, TEventArgs, TAltEventArgs> : TestPublisher<TSender, TEventArgs>,
            ITestPublisher<TSender, TEventArgs>,
            ITestPublisher,
            IGloballyIdentifiable
        where TSender : TestPublisher<TSender, TEventArgs, TAltEventArgs>
    {

        public TestPublisher(IEventAggregatorGeneric eventAggregator) : base(eventAggregator)
        {
            EventAggregator = eventAggregator;
        }

        /// <summary>Publishes notification with alternative <paramref name="eventArgs"/> type, the <typeparamref name="TAltEventArgs"/>.</summary>
        /// <param name="sender">Sender of notification / originator of event.</param>
        /// <param name="eventArgs">Notification / event data.</param>
        /// <remarks>Delegates work to <see cref="CustomTypePublish{TSenderCustSig, TEventArgsCustSig}(TSenderCustSig, TEventArgsCustSig)"/>
        /// That should be thread safe.</remarks>
        public void PublishAlt(TSender sender, TAltEventArgs eventArgs)
        {
            CustomTypePublish<TSender, TAltEventArgs>(sender, eventArgs);
        }

        /// <summary>Publishes notification with alternative <paramref name="eventArgs"/> type, the <typeparamref name="TAltEventArgs"/>.</summary>
        /// <param name="sender">Sender of notification / originator of event.</param>
        /// <param name="eventArgs">Notification / event data.</param>
        /// <remarks>Delegates work to <see cref="CustomTypePublish{TSenderCustSig, TEventArgsCustSig}(TSenderCustSig, TEventArgsCustSig)"/>
        /// That should be thread safe.</remarks>
        public void PublishAltPlain(object sender, TAltEventArgs eventArgs)
        {
            CustomTypePublish<object, TAltEventArgs>(sender, eventArgs);
        }

    }

}
