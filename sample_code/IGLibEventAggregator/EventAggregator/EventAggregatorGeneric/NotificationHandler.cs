// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IG.Lib.Events
{

    /// <summary>Delegate used to handle events (notifications) form event aggregators (see e.g. <see cref="IEventAggregatorGeneric"/>).
    /// Objects that implement the <see cref="INotificationSubscriber{TSender, TEventArgs}"/> can subscribe this kind of delegate for
    /// notifications from event aggregators.
    /// <para>Objects of type <see cref="INotificationSubscriber{TSender, TEventArgs}"/> expose a method that is compatible with this delegate.</para></summary>
    /// <typeparam name="TSender">Type of the sender parameter.</typeparam>
    /// <typeparam name="TEventArgs">Type of the eventArgs parameter.</typeparam>
    /// <param name="sender">Object that had sent / generated the notification / event handled by the current delegate.</param>
    /// <param name="eventArgs">Paremeters of the event / notification, containing all the necessary information to handle the event.</param>
    /// <seealso cref="INotificationSubscriber{TSender, TEventArgs}"/>
    public delegate void NotificationHandler<TSender, TEventArgs>(TSender sender, TEventArgs eventArgs)
        where TSender : class;

    /// <summary>Restriction of generic <see cref="NotificationFilter{TEventArgs, TFilterData}"/> dleegate to cases where
    /// sender type is sent simply to <see cref="object"/>.</summary>
    /// <typeparam name="TEventArgs">The same as in <see cref="NotificationHandler{TSender, TEventArgs}"/>.</typeparam>
    /// <param name="sender">The same as in <see cref="NotificationHandler{TSender, TEventArgs}"/>.</param>
    /// <param name="eventArgs">The same as in <see cref="NotificationHandler{TSender, TEventArgs}"/>.</param>
    /// <see cref="NotificationHandler{TSender, TEventArgs}"/>
    public delegate void NotificationHandler<TEventArgs>(object sender, TEventArgs eventArgs);

}
