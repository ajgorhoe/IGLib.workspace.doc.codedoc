// Copyright (c) Igor Grešovnik (2008 - present); Part of Investigative Generic Library.
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IG.Lib;

namespace IG.Tests.Events
{

    /// <summary>Base class for classes whose objects have a unique application-wide ID.</summary>
    public abstract class GloballyIdentifiableTestUtil: GloballyIdentifiableBase, IGloballyIdentifiable
    {

        /// <summary>Used for locking internal resources by classes that need certain thread safety properties.</summary>
        protected object Lock { get; } = new object();

        /// <summary>Whether or not actions performed are printeed to console.</summary>
        public virtual bool ConsoleOutput { get; set; } = true;

        public override string ToString()
        {
            return $"{{{GetType()}: OID = {ObjectId}}}";
        }

    }


        public class TestEventInfo: GloballyIdentifiableTestUtil, IGloballyIdentifiable
        {

        public TestEventInfo(object sender, object eventArgs)
        {
            SenderObject = sender;
            EventArgsObject = eventArgs; 
        }

        public object SenderObject { get; protected set; }

        public object EventArgsObject { get; protected set; }

        public ITestPublisher SenderTestable {
            get {
                return SenderObject == null? null: SenderObject as ITestPublisher;
            }
        }

        public ITestEventData EventArgsTestable {
            get
            {
                return EventArgsObject == null? null: EventArgsObject as ITestEventData;
            } 
        }

        /// <summary>Returns <see cref="IGloballyIdentifiable.ObjectId"/> of the event's data, 
        /// or -1 if event's data does not exist.</summary>
        public int DataId { get { return EventArgsTestable == null ? -1 : EventArgsTestable.ObjectId;  } }

    }






}
