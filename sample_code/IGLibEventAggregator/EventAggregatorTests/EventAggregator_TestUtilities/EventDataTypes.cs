// Copyright (c) Igor Grešovnik (2008 - present); Investigative Generic Library's experimentation project.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IG.Lib;

namespace IG.Tests.Events
{

    /// <summary>Marker interfaces for event data types used for tests.
    /// <para>In general, event data types don'n need to implement any interface and can even be value types.</para></summary>
    public interface ITestEventData: IGloballyIdentifiable
    {  }

    public class WindowData: GloballyIdentifiableTestUtil, ITestEventData, 
        IGloballyIdentifiable
    {
        public WindowData(string windowName, int windowHandle, string ownerName) 
        { WindowName = windowName; WindowHandle = windowHandle; OwnerName = ownerName; }
        public string WindowName { get; protected set; }
        public int WindowHandle { get; protected set; }
        public string OwnerName { get; protected set; }
        public override string ToString()
        {
            return $"{GetType().Name}: OID={ObjectId}, Windowname={WindowName}, WindowHandle={WindowHandle}, OwnerName={OwnerName}";
        }
    }

    public class CityData: GloballyIdentifiableTestUtil, ITestEventData, 
        IGloballyIdentifiable
    {
        public CityData(string name, int inhabitants) 
        { Name = name; Inhabitants = inhabitants; }
        public string Name { get; protected set; }
        public int Inhabitants { get; protected set; }
        public override string ToString()
        {
            return $"{GetType().Name}: OID={ObjectId}, Name={Name}, Inhabitants={Inhabitants}";
        }
    }


    public class CityDataExtended : CityData, ITestEventData, 
        IGloballyIdentifiable
    {
        public CityDataExtended(string name, int inhabitants, double rating) : base(name, inhabitants)
        { Rating = rating; }
        public double Rating { get; protected set; }
        public override string ToString()
        {
            return $"{GetType().Name}: OID={ObjectId}, Name={Name}, Inhabitants={Inhabitants}, Rating={Rating}";
        }
    }

}
