// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IG.Lib.Events
{
    
    /// <summary>Used for evaluation of notification / event filtering condition. Objects of type <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}"/>
    /// implement a method compatible with this delegate.</summary>
    /// <typeparam name="TSender"></typeparam>
    /// <typeparam name="TEventArgs"></typeparam>
    /// <typeparam name="TFilterData"></typeparam>
    /// <param name="sender"></param>
    /// <param name="eventArgs"></param>
    /// <param name="filterData"></param>
    /// <returns></returns>
    public delegate bool NotificationFilterWithDataDelegate<TSender, TEventArgs, TFilterData>(TSender sender, TEventArgs eventArgs, TFilterData filterData)
        where TSender: class
        where TFilterData: class;
    
    /// <summary>Used for evaluation of notification / event filtering condition. Objects of type <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}"/>
    /// implement a method compatible with this delegate.</summary>
    /// <typeparam name="TSender"></typeparam>
    /// <typeparam name="TEventArgs"></typeparam>
    /// <param name="sender"></param>
    /// <param name="eventArgs"></param>
    /// <returns></returns>
    public delegate bool NotificationFilterDelegate<TSender, TEventArgs>(TSender sender, TEventArgs eventArgs)
        where TSender: class;

    /// <summary>Restriction of <see cref="NotificationFilterWithDataDelegate{TSender, TEventArgs, TFilterData}"/> to cases where sender parameter is simply
    /// of type <see cref="object"/>. This is often used in situations where we don't want to restrict subscribers to receive events from only a
    /// particular type of senders.</summary>
    /// <typeparam name="TEventArgs"></typeparam>
    /// <typeparam name="TFilterData"></typeparam>
    /// <param name="sender"></param>
    /// <param name="eventArgs"></param>
    /// <param name="filterData"></param>
    /// <returns></returns>
    public delegate bool NotificationFilterWithDataDelegate<TEventArgs, TFilterData>(object sender, TEventArgs eventArgs, TFilterData filterData)
        where TFilterData : class;


    /// <summary>Used for evaluation of notification / event filtering condition. Objects of type <see cref="INotificationFilter{TSender, TEventArgs, TFilterData}"/>
    /// implement a method compatible with this delegate.</summary>
    /// <typeparam name="TEventArgs"></typeparam>
    /// <param name="sender"></param>
    /// <param name="eventArgs"></param>
    /// <returns></returns>
    public delegate bool NotificationFilterDelegate<TEventArgs>(object sender, TEventArgs eventArgs);

}
