// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IG.Lib.Events
{

    public class NotificationSubscriber<TSender, TEventArgs> : INotificationSubscriber<TSender, TEventArgs>
        where TSender : class
    {

        public NotificationSubscriber(NotificationHandler<TSender, TEventArgs> handlerDelegate)
        {
            HandlerDelegate = handlerDelegate;
        }

        public NotificationSubscriber(INotificationSubscriber<TSender, TEventArgs> handlerObject)
        {
            HandlerObject = handlerObject;
        }

        protected virtual NotificationHandler<TSender, TEventArgs> HandlerDelegate { get; private set; }

        protected virtual INotificationSubscriber<TSender, TEventArgs> HandlerObject { get; private set; }

        public virtual void HandleNotification(TSender sender, TEventArgs eventArgs)
        {
            if (HandlerObject != null)
            {
                if (HandlerDelegate != null)
                {
                    throw new InvalidOperationException("Both notification handler object and delegate are specified, do not know which one to use.");
                }
                HandlerObject.HandleNotification(sender, eventArgs);
                return;
            }
            if (HandlerDelegate != null)
            {
                HandlerDelegate(sender, eventArgs);
                return;
            }
            throw new InvalidOperationException("Neither notification object nor delegate is specified.");
        }

    }

    public class NotificationSubscriber<TEventArgs>: NotificationSubscriber<object, TEventArgs>, 
            INotificationSubscriber<TEventArgs>
    {

        public NotificationSubscriber(NotificationHandler<object, TEventArgs> handlerDelegate): base(handlerDelegate)
        {  }

        public NotificationSubscriber(INotificationSubscriber<object, TEventArgs> handlerObject): base(handlerObject)
        { }

    }





}
