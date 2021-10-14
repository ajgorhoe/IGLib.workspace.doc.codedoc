// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Text;

namespace IG.Lib.Events
{

    /// <summary>Represent objects that contain the event handler that can be subscribed to specific types of events (notifications)
    /// - the <see cref="HandleNotification(TSender, TEventArgs)"/>.</summary>
    /// <typeparam name="TSender">Type of the sender parameter of events (notifications) that can be handled (subscribed to) by the current
    /// object.
    /// <param>In many cases, notifications will have this type simply set to <see cref="object"/>, such that notifications can be caught
    /// by a broad number of subscribers, that don't need to rely on the actual type.</param></typeparam>
    /// <typeparam name="TEventArgs">Type of the data parameter of events (notifications) that can be handled (subscribed to) by the current
    /// object.
    /// <para>Objects of this type are used to carry with notifications (events) all the data necessary by interested subscribers. 
    /// Simutaneously this type is used to </para></typeparam>
    public interface INotificationSubscriber<TSender, TEventArgs>
        where TSender: class
    {

        void HandleNotification(TSender sender, TEventArgs eventArgs);

    }

    /// <summary>Derived form <see cref="INotificationSubscriber{TSender, TEventArgs}"/>, represent objects containing
    /// subscribable event handlers where the sender parameter is by convention of plain <see cref="object"/> type, normally
    /// used for groups of notifications sent from broader types of objects.</summary>
    /// <typeparam name="TEventArgs">Type of event data parameterr of events (notifications).</typeparam>
    public interface INotificationSubscriber<TEventArgs> : INotificationSubscriber<object, TEventArgs>
    {  }


}
