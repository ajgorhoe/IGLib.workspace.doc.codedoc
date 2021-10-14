// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IG.Lib.Events
{



    public class NotificationFilterWithData<TSender, TEventArgs, TFilterData> : INotificationFilterWithData<TSender, TEventArgs, TFilterData>
        where TSender : class
        where TFilterData : class
    {

        public NotificationFilterWithData(NotificationFilterWithDataDelegate<TSender, TEventArgs, TFilterData> filterDelegate, TFilterData filterData)
        {
            FilterDelegate = filterDelegate;
            FilterData = filterData;
        }

        public NotificationFilterWithData(INotificationFilterWithData<TSender, TEventArgs, TFilterData> filterObject)
        {
            FilterObject = filterObject;
        }

        protected virtual NotificationFilterWithDataDelegate<TSender, TEventArgs, TFilterData> FilterDelegate { get; private set; }

        public virtual TFilterData FilterData { get; private set; }

        protected virtual INotificationFilterWithData<TSender, TEventArgs, TFilterData> FilterObject { get; private set; }

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
                return FilterDelegate(sender, eventArgs, FilterData);
            }
            throw new InvalidOperationException("Neither notification filter nor filter delegate is specified.");
        }

    }

    public class NotificationFilterWithData<TEventArgs, TFilterData> : NotificationFilterWithData<object, TEventArgs, TFilterData>,
            INotificationFilterWithData<TEventArgs, TFilterData>
        where TFilterData : class
    {

        public NotificationFilterWithData(NotificationFilterWithDataDelegate<object,
            TEventArgs, TFilterData> filterDelegate, TFilterData filterData) : base(filterDelegate, filterData)
        { }

        public NotificationFilterWithData(INotificationFilterWithData<object, TEventArgs, TFilterData> filterObject) : base(filterObject)
        { }

    }


}
