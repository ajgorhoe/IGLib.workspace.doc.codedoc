// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IG.Lib.Events
{



    public class NotificationFilter<TSender, TEventArgs> : INotificationFilter<TSender, TEventArgs>
        where TSender : class
    {

        public NotificationFilter(NotificationFilterDelegate<TSender, TEventArgs> filterDelegate)
        {
            FilterDelegate = filterDelegate;
        }

        public NotificationFilter(INotificationFilter<TSender, TEventArgs> filterObject)
        {
            FilterObject = filterObject;
        }

        protected virtual NotificationFilterDelegate<TSender, TEventArgs> FilterDelegate { get; private set; }

        protected virtual INotificationFilter<TSender, TEventArgs> FilterObject { get; private set; }

        public virtual bool Matches(TSender sender, TEventArgs eventArgs)
        {
            if (FilterObject != null)
            {
                if (FilterDelegate != null)
                {
                    throw new InvalidOperationException("Both notification filter object and delegate are specified, do not know which one to use.");
                }
                return FilterObject.Matches(sender, eventArgs);
            }
            if (FilterDelegate != null)
            {
                return FilterDelegate(sender, eventArgs);
            }
            throw new InvalidOperationException("Neither notification filter nor filter delegate is specified.");
        }

    }

    public class NotificationFilter<TEventArgs> : NotificationFilter<object, TEventArgs>,
            INotificationFilter<TEventArgs>
    {

        public NotificationFilter(NotificationFilterDelegate<object, TEventArgs> filterDelegate) : base(filterDelegate)
        { }

        public NotificationFilter(INotificationFilter<object, TEventArgs> filterObject) : base(filterObject)
        { }

    }


}
