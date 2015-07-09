<!---
This CFC is released under the Apache 2.0 License
For more info, read: http://www.apache.org/licenses/LICENSE-2.0

Author Chuck Savage
© Copyright SeaRisen LLC 2009
Created November of 2009

Need to ReplaceAll
mg.model.linkedlist.link with (your location)
mg.model.linkedlist.iterator with (your location)

See the documentation at: 
http://linkedlist.riaforge.org/wiki/index.cfm/LinkedList_API

--->
<cfcomponent name="LinkedList" output="false">  
	<cfset Init()>
  
<cffunction name="Init" returntype="any" access="public" output="false"> 
	<cfset variables.first = "">
  <cfset variables.last = "">
  <cfset variables.iterator = this.Iterator()> <!--- needs this. --->
  <cfset variables.length = 0>
	<cfreturn this />  
</cffunction>  

<!---
This becomes undefined/invalid if Add, Push, Pop or PopBack are called
after this is created.
--->
<cffunction name="Iterator" 
						returntype="mg.model.linkedlist.iterator" 
            access="public" 
            output="false" 
            description="Current Iterator (with .prev and .next links, .value for value set)">  
	<cfset var i = CreateObject("component", "mg.model.linkedlist.iterator")>
  
  <cfif NOT IsEmpty()>
	  <cfset i.Init( variables.first, variables.last )>            
  </cfif>
	
  <cfreturn i>
</cffunction>  

<cffunction name="IsEmpty" 
						returntype="boolean" 
            access="public" 
            output="false" 
            description="Is list empty"> 
	<cfreturn IsSimpleValue( variables.first )>
</cffunction>  

<cffunction name="Clear"
						returntype="void"
            access="public"
            output="false"
            description="Set list to blank state"
            >
	<cfset Init()>
</cffunction>  

<cffunction name="Add" 
						returntype="void" 
            access="public" 
            output="false" 
            description="Add to end of list, resets iterator to first">  
  <cfargument name="value" type="any" required="yes" hint="Value to add">
  
  <cfset var link = CreateObject("component","mg.model.linkedlist.link")>
  <cfset link.value = arguments.value>

	<cfif IsEmpty()>
		<cfset variables.first = link>
    <cfset variables.last = link>
  <cfelse>
  	<cfset link.SetPrev(variables.last)>
    <cfset variables.last.SetNext(link)>
    <cfset variables.last = link>
	</cfif>
  <cfset iterator.Init(variables.first, variables.last)>
  <cfset variables.length = variables.length + 1>
</cffunction>  

<cffunction name="Push" 
						returntype="void" 
            access="public" 
            output="false" 
            description="Add to front of list, resets iterator to first">  
  <cfargument name="value" type="any" required="yes" hint="Value to add">
  
  <cfset var link = CreateObject("component","mg.model.linkedlist.link")>
  <cfset link.value = arguments.value>

	<cfif IsEmpty()>
		<cfset variables.first = link>
    <cfset variables.last = link>
  <cfelse>
  	<cfset link.SetNext(variables.first)>
    <cfset variables.first.SetPrev(link)>
    <cfset variables.first = link>
	</cfif>
  <cfset iterator.Init(variables.first, variables.last)>
  <cfset variables.length = variables.length + 1>
</cffunction>  

<cffunction name="InsertAt" 
						returntype="void" 
            access="public" 
            output="false" 
            description="Add a value at iterator position">
  <cfargument name="value" type="any" required="yes" hint="Value to add">
  <cfargument name="iterator" type="mg.model.linkedlist.iterator" required="no" 
  		hint="Iterator position to insert at" default="#variables.iterator#">
	  
  <cfset var prev = 0>
  <cfset var current = 0>
  <cfset var link = CreateObject("component","mg.model.linkedlist.link")>
  <cfset link.value = arguments.value>

	<cfif IsEmpty()>
		<cfset variables.first = link>
    <cfset variables.last = link>
  <cfelse>
  	<cfset current = arguments.iterator.currentLink>
		<cfif IsSimpleValue(current)>
      <cfthrow message="Invalid iterator to method InsertAt()" />
    </cfif>
    <cfif current.HasPrev()>
	    <cfset prev = current.GetPrev()>
	    <cfset link.SetPrev(prev)>
      <cfset prev.SetNext(link)>
    <cfelse>
			<cfset variables.first = link>
    </cfif>
    <cfset link.SetNext(current)>
    <cfset current.SetPrev(link)>
	</cfif>
  <!--- if these two are the same, oh well --->
  <cfset variables.iterator.Init(variables.first, variables.last)>
  <cfset arguments.iterator.Init(variables.first, variables.last)>
  
  <cfset variables.length = variables.length + 1>
</cffunction>  

<cffunction name="Pop" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Pop value from front, resets iterator to first">  
	<cfset var value = this.First()>  <!--- throws if empty --->
	<cfset var next = variables.first.GetNext()> <!--- first guarenteed to have a value, since we'd throw if empty --->

  <cfset variables.first = next>
  <!--- Do we only have one or no values left? --->
	<cfif IsSimpleValue( next )>
		<cfset variables.last = next>
  <cfelse>
	  <cfset next.ClearPrev()>
	</cfif>
	<cfset UpdateIterator()>
  <cfset variables.length = variables.length - 1>
	<cfreturn value>
</cffunction>  

<cffunction name="PopBack" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Pop value end of list, resets iterator to first">  

	<cfset var value = this.Last()>  <!--- throws if empty --->
	<cfset var prev = variables.last.GetPrev()> <!--- last guarenteed to have a value, since we'd throw if empty --->

  <cfset variables.last = prev>
  <!--- Are we now empty? --->
	<cfif IsSimpleValue( prev )>
		<cfset variables.first = prev>
  <cfelse>
	  <cfset prev.ClearNext()>
	</cfif>
	<cfset UpdateIterator()>
  <cfset variables.length = variables.length - 1>
	<cfreturn value>
</cffunction>  

<cffunction name="UpdateIterator" access="private" output="no" returntype="void">
	<cfif IsEmpty()>
  	<cfset variables.iterator.Clear()>
  <cfelse>
  	<cfset variables.iterator.Init(variables.first, variables.last)>
	</cfif>  
</cffunction>

<cffunction name="ValidateList" 
						returntype="void" 
            access="private" 
            output="false" 
            description="Validate list">  
	<cfif IsEmpty()>
		<cfthrow message="Linked list empty">
	</cfif>
</cffunction>  

<cffunction name="ValidateIterator" 
						returntype="void" 
            access="private" 
            output="false" 
            description="Validate Iterator">  
	<cfif IsSimpleValue( variables.iterator )>
		<cfthrow message="Iterator invalid">
	</cfif>
</cffunction>  

<cffunction name="First" 
						returntype="any" 
            access="public" 
            output="false" 
            description="First value, sets iterator to first">  
	<!--- Iterator.First() throws if invalid list --->
	<cfreturn variables.iterator.First()> 
</cffunction>  

<cffunction name="Last" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Last value, sets iterator to last"> 
	<!--- Iterator.Last() throws if invalid list --->
	<cfreturn variables.iterator.Last()> 
</cffunction>  

<cffunction name="Value" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Get current value if it exists, doesn't move iterator">
	<!--- Iterator.Value() throws if invalid list --->
	<cfreturn variables.iterator.Value()>
</cffunction>

<cffunction name="Next" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Next value, if it exists, moves iterator">
	<!--- Iterator.Next() throws if invalid list --->
	<cfreturn variables.iterator.Next()>
</cffunction>

<cffunction name="Prev" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Previous value, if it exists, moves iterator backwards">
	<!--- Iterator.Prev() throws if invalid list --->
	<cfreturn variables.iterator.Prev()>
</cffunction>

<cffunction name="Length"
						returntype="numeric"
            access="public"
            output="false"
            description="Get the size of the list">
	<cfreturn variables.length>
</cffunction>

<cffunction name="Dump" access="public">
	<cfset iterator.First()>
  	<table>
    	<th>Value</th><th>Previous</th><th>Next</th>
  <cfloop condition="iterator.loop()">
    <tr>
      <td>
      <cfdump var="#iterator.Value()#">
      </td>
      <td>
      <cfif NOT iterator.HasPrev()>
        (null)
      <cfelse>
        <cfdump var="#iterator.PrevValue()#">
      </cfif>
      </td>
      <td>
      <cfif NOT iterator.HasNext()>
        (null)
      <cfelse>
        <cfdump var="#iterator.NextValue()#">
      </cfif>
      </td>
    </tr>
  </cfloop>
  	</table><br>
</cffunction>

<cffunction name="DumpValues" access="public">
	<cfset iterator.First()>
  <cfloop condition="iterator.loop()">
  	<cfdump var="#iterator.Value()#">
  </cfloop>
</cffunction>

</cfcomponent>
