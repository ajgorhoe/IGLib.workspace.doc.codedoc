// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IG.Lib.Events
{
    
    /// <summary>Default implementatino of <see cref="INotificationSubscription{TSender, TEventArgs, TFilterData}"/>.</summary>
    /// <typeparam name="TSender">Type of the sender parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
    /// and (optinally) in <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}.Matches(TSender, TEventArgs, TFilterData)"/>.</typeparam>
    /// <typeparam name="TEventArgs">Type of event data parameter in <see cref="INotificationSubscriber{TSender, TEventArgs}.HandleNotification(TSender, TEventArgs)"/>
    /// and eventually (optinally) in <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}.Matches(TSender, TEventArgs, TFilterData)"/>.</typeparam>
    /// <typeparam name="TFilterData">Type of filter data parameter in <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}.Matches(TSender, TEventArgs, TFilterData)"/>.</typeparam>
    public class NotificationSubscription<TSender, TEventArgs> : INotificationSubscription<TSender, TEventArgs>
        where TSender : class
        // where TFilterData : class
    {


        public NotificationSubscription(INotificationSubscriber<TSender, TEventArgs> notificationSubscriber,
            INotificationFilter<TSender, TEventArgs> notificationFilter = null):
                this(notificationSubscriber, notificationFilter, typeof(TSender), typeof(TEventArgs))
        { }

        protected NotificationSubscription(INotificationSubscriber<TSender, TEventArgs> notificationSubscriber, 
            INotificationFilter<TSender, TEventArgs> notificationFilter,
            Type senderType, Type eventArgsType)
        {
            Subscriber = notificationSubscriber;
            Filter = notificationFilter;
            SenderType = senderType;
            EventArgsType = eventArgsType;
        }

        /// <summary>Object to which invocation of notification / event handler is passed.</summary>
        public INotificationSubscriber<TSender, TEventArgs> Subscriber { get; protected set; }

        /// <summary>Optional filter object that performs filtering of the notifications to which this subsctiption applies.
        /// If specified then event aggregator will not pass to <see cref="Subscriber"/> those otherwise eligible notifications
        /// for which teh <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}.Matches(TSender, TEventArgs, TFilterData)"/> evaluates to false.</summary>
        public INotificationFilter<TSender, TEventArgs> Filter { get; protected set; }

        public Type SenderType { get; private set; }

        public Type EventArgsType { get; private set; }

    }

}
