// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Text;

namespace IG.Lib.Events
{
    
    /// <summary>Base subscription interface, to be able to store notification objects of tpye <see cref="INotificationSubscription{TSender, TEventArgs, TFilterData}"/>
    /// with differnt type parameters in the same subscription collection.
    /// <para>Contains properties specifying types of the specific event handler and filter that are part of subscription (<see cref="SenderType"/>,
    /// <see cref="EventArgsType"/>, <see cref="FilterDataType"/>). These types are used to generate the access key for accessing the subscription
    /// based on the mentioned types.</para> </summary>
    /// <seealso cref="INotificationSubscription{TSender, TEventArgs, TFilterData}"/>
    /// <seealso cref="IEventAggregatorGeneric"/>
    public interface INotificationSubscription
    {

        /// <summary>Type of the sender parameter in the event handler that is used for the current subscription.
        /// Used in the <see cref="NotificationHandler{TSender, TEventArgs}"/> delegate and the related 
        /// <see cref="INotificationSubscriber{TSender, TEventArgs}"/> interface. Also used in filter delegate 
        /// and interface (see description of <see cref="FilterDataType"/>).</summary>
        Type SenderType { get; }

        /// <summary>Type of the event data parameter in the event handler that is used for the current subscription.
        /// Used in the <see cref="NotificationHandler{TSender, TEventArgs}"/> delegate and the related 
        /// <see cref="INotificationSubscriber{TSender, TEventArgs}"/> interface. Also used in filter delegate 
        /// and interface (see description of <see cref="FilterDataType"/>).</summary>
        Type EventArgsType { get; }


        ///// <summary>Type of the event filter parameter in the event filter that is used for the current subscription.
        ///// Used in the <see cref="NotificationFilterDelegate{TSender, TEventArgs, TFilterData}"/> delegate and the related 
        ///// <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}"/> interface.</summary>
        //Type FilterDataType { get; }
    
    }


    /// <summary>Subscription token used to register subscription in the event aggregators and to unsubscribe the specific subscription.
    /// <para>The <see cref="Subscriber"/> property is used to invoke the subscribed notification handler.</para>
    /// <para>The optional <see cref="Filter"/> property is used to apply eventual filter on the potential notifications, such that
    /// only the matching (not filtered out) notifications actually cause invocation of the <see cref="Subscriber"/>'s event handler 
    /// (<see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>).</para>
    /// <para>Contains types of the related handler and filter delegates (inherited from <see cref="INotificationSubscription"/>), which 
    /// are used to generate the access key in the event aggregator (see <see cref="IEventAggregatorGeneric"/>), to be able to find the 
    /// matching subscriptions for specific types of event notifications. 
    /// These types are <see cref="INotificationSubscription.SenderType"/>, <see cref="INotificationSubscription.EventArgsType"/> and <see cref="INotificationSubscription.FilterDataType"/>.</para>
    /// <para>Based on <see cref="INotificationSubscription"/>.</para></summary>
    /// <typeparam name="TSender">Type of the sender parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
    /// and in the filter (see <typeparamref name="TFilterData"/>).</typeparam>
    /// <typeparam name="TEventArgs">Type of the event data parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
    /// and in the filter (see <typeparamref name="TFilterData"/>).</typeparam>
    /// <typeparam name="TFilterData">Type of the filter data parameter in <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}.Matches(TSender, TEventArgs, TFilterData)"/>
    /// metohd used to filter out notifications that subscriber does not want to receive.</typeparam>
    /// <seealso cref="INotificationSubscription"/>
    /// <seealso cref="IEventAggregatorGeneric"/>
    /// <see cref="INotificationSubscriber{TSender, TEventArgs}"/>
    /// <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}"/>
    public interface INotificationSubscription<TSender, TEventArgs> : INotificationSubscription
        where TSender : class
    {

        /// <summary>Object on which the notification / event handler (<see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>) 
        /// is invoked by the event aggregator for all notifications for which the current subscription applies (except when filtered out by the optional 
        /// <see cref="Filter"/> object).</summary>
        INotificationSubscriber<TSender, TEventArgs> Subscriber { get; }

        /// <summary>Optional. When specified, this object performs additional custom filtering of notifications that are otherwise eligible for
        /// the current subscription.</summary>
        INotificationFilter<TSender, TEventArgs> Filter { get; }

    }


    /// <summary>Subscription token used to register subscription in the event aggregators and to unsubscribe the specific subscription.
    /// <para>The <see cref="Subscriber"/> property is used to invoke the subscribed notification handler.</para>
    /// <para>The optional <see cref="Filter"/> property is used to apply eventual filter on the potential notifications, such that
    /// only the matching (not filtered out) notifications actually cause invocation of the <see cref="Subscriber"/>'s event handler 
    /// (<see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>).</para>
    /// <para>Contains types of the related handler and filter delegates (inherited from <see cref="INotificationSubscription"/>), which 
    /// are used to generate the access key in the event aggregator (see <see cref="IEventAggregatorGeneric"/>), to be able to find the 
    /// matching subscriptions for specific types of event notifications. 
    /// These types are <see cref="INotificationSubscription.SenderType"/>, <see cref="INotificationSubscription.EventArgsType"/> and <see cref="INotificationSubscription.FilterDataType"/>.</para>
    /// <para>Based on <see cref="INotificationSubscription"/>.</para></summary>
    /// <typeparam name="TSender">Type of the sender parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
    /// and in the filter (see <typeparamref name="TFilterData"/>).</typeparam>
    /// <typeparam name="TEventArgs">Type of the event data parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
    /// and in the filter (see <typeparamref name="TFilterData"/>).</typeparam>
    /// <typeparam name="TFilterData">Type of the filter data parameter in <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}.Matches(TSender, TEventArgs, TFilterData)"/>
    /// metohd used to filter out notifications that subscriber does not want to receive.</typeparam>
    /// <seealso cref="INotificationSubscription"/>
    /// <seealso cref="IEventAggregatorGeneric"/>
    /// <see cref="INotificationSubscriber{TSender, TEventArgs}"/>
    /// <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}"/>
    public interface INotificationSubscription<TSender, TEventArgs, TFilterData>: INotificationSubscription, INotificationSubscription<TSender, TEventArgs>
        where TSender: class
        where TFilterData: class
    {

        ///// <summary>Object on which the notification / event handler (<see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>) 
        ///// is invoked by the event aggregator for all notifications for which the current subscription applies (except when filtered out by the optional 
        ///// <see cref="Filter"/> object).</summary>
        //INotificationSubscriber<TSender, TEventArgs> Subscriber { get; }

        ///// <summary>Optional. When specified, this object performs additional custom filtering of notifications that are otherwise eligible for
        ///// the current subscription.</summary>
        //INotificationFilter<TSender, TEventArgs> Filter { get; }

    }


}
