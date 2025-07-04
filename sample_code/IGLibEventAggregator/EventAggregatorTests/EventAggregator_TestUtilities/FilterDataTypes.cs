// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IG.Lib;

namespace IG.Tests.Events
{

    /// <summary>Marker interfaces for filter data types used for tests.
    /// <para>In general, filter data types don'n need to implement any interface but must be reference types.</para></summary>
    public interface ITestFilterData : IGloballyIdentifiable
    { }

    public class CityFilterData: GloballyIdentifiableTestUtil, ITestFilterData, IGloballyIdentifiable
    {
        public CityFilterData(int minInhabitants = 0, int maxInhabitants = 50000000, double minRating = 0.0, double maxRating = 10.0)
        {
            MinInhabitants = minInhabitants;
            MaxInhabitants = maxInhabitants;
            MinRating = minRating;
            MaxRating = maxRating;
        }
        public int MinInhabitants { get; set; }
        public int MaxInhabitants { get; set; }
        public double MinRating { get; set; }
        public double MaxRating { get; set; }
        public override string ToString()
        {
            return $"{GetType().Name}: OID={ObjectId}, Inhabitants range = {MinInhabitants}-{MaxInhabitants}, Rating range = {MinRating}-{MaxRating}.";
        }
    }
}
