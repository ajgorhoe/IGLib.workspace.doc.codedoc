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
    public class CityFilter<TSender> : GloballyIdentifiableTestUtil, 
        INotificationFilterWithData<TSender, CityDataExtended, CityFilterData>, IGloballyIdentifiable
        where TSender: class
    {

        public CityFilter(CityFilterData filterData = null)
        {
            FilterData = filterData;
        }

        public CityFilterData FilterData { get; set; }
        public virtual bool Matches(TSender sender, CityDataExtended eventArgs)
        {
            if (FilterData == null)
                return true;
            if (eventArgs == null)
                return false;
            if (eventArgs.Inhabitants < FilterData.MinInhabitants)
                return false;
            if (eventArgs.Inhabitants > FilterData.MaxInhabitants)
                return false;
            return true;
        }
    }

    public class CityFilterExtended<TSender> : CityFilter<TSender>, 
        INotificationFilterWithData<TSender, CityDataExtended, CityFilterData>,
        INotificationFilter<TSender, CityDataExtended>,
        IGloballyIdentifiable
        where TSender: class
    {

        public CityFilterExtended(CityFilterData filterData = null): base(filterData)
        {
            FilterData = filterData;
        }

        public override bool Matches(TSender sender, CityDataExtended eventArgs)
        {
            if (FilterData == null)
                return true;
            if (eventArgs == null)  // filters can also perform baisc data validation!
                return false;
            // Pay attention below: this is possible because CityDataExtended extends CityData; common approach used in filtering
            if (!base.Matches(sender, eventArgs)) 
                return false;
            // Remark: instead of extending SityFilter, we could simply check in base class if CityData can be casted to CityDataExtended
            // and evaluate lines below if yes.
            if (eventArgs.Rating < FilterData.MinRating)
                return false;
            if (eventArgs.Rating > FilterData.MaxRating)
                return false;
            return true;
        }
    }

}
