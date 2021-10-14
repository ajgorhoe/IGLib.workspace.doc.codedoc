// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Text;

namespace IG.Lib.Events
{


    public interface INotificationFilterWithData<TSender, TEventArgs, TFilterData>: INotificationFilter<TSender, TEventArgs>
        where TSender: class
        where TFilterData: class
    {

        TFilterData FilterData { get; }

    }

    public interface INotificationFilter<TSender, TEventArgs>
        where TSender: class
    {

        bool Matches(TSender sender, TEventArgs eventArgs);

    }


    public interface INotificationFilterWithData<TEventArgs, TFilterData> : INotificationFilterWithData<object, TEventArgs, TFilterData>
        where TFilterData: class
    { }

    public interface INotificationFilter<TEventArgs> : INotificationFilter<object, TEventArgs>
    {  }



}
