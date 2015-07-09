<!---
This CFC is released under the Apache 2.0 License
For more info, read: http://www.apache.org/licenses/LICENSE-2.0

Author Chuck Savage
© Copyright SeaRisen LLC 2009
Created December of 2009

Need to ReplaceAll
mg.model.linkedlist.link with (your location)

See the documentation at: 
http://linkedlist.riaforge.org/wiki/index.cfm/Iterator_API
--->
<cfcomponent name="Iterator" output="false">  

<!--- Each of these are Link.cfc's or "" (null) values --->   
	<cfscript>
  variables.first = ""; // first link
	variables.last = ""; // last link
	this.currentLink = ""; // current link
  </cfscript>
<!--- currentLink in THIS scope, so linkedlist.InsertAt() can insert new values. --->

<cffunction name="Dump" returntype="void" access="public" output="yes">
	<br><u>Iterator Dump</u><br>
	<cfdump var="#variables.first#" expand="no" />
	<cfdump var="#variables.last#" expand="no" />
	<cfdump var="#this.currentLink#" expand="no" />
</cffunction>

<cffunction name="Init" returntype="any" access="public" output="false"> 
	<cfargument name="first" type="mg.model.linkedlist.link" required="yes">
	<cfargument name="last" type="mg.model.linkedlist.link" required="yes">
	<cfset variables.first = first>
  <cfset variables.last = last>
  <cfset this.currentLink = first>
	<cfreturn this />  
</cffunction>  

<cffunction name="Clear" returntype="void" access="public" output="no"
	hint="this will invalidate the iterator and cause it to throw errors if values are accessed">
	<cfset this.currentLink = "">
</cffunction>

<cffunction name="ValidateIterator" 
						returntype="void" 
            access="private" 
            output="false" 
            description="Validate Iterator">  
	<cfif IsSimpleValue( this.currentLink )>
		<cfthrow message="Need to Init() iterator OR container is empty">
	</cfif>
</cffunction>  

<cffunction name="First" 
						returntype="any" 
            access="public" 
            output="false" 
            description="First value, sets iterator to first">  
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
	<cfset this.currentLink = variables.first>
	<cfreturn this.currentLink.value>
</cffunction>  

<cffunction name="Last" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Last value, sets iterator to last"> 
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
	<cfset this.currentLink = variables.last>
	<cfreturn this.currentLink.value>
</cffunction>  

<cffunction name="Value" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Get current value if it exists, doesn't move iterator">
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
	<cfreturn this.currentLink.value>
</cffunction>

<cffunction name="SetValue" 
						returntype="void" 
            access="public" 
            output="false" 
            description="Get current value if it exists, doesn't move iterator">
  <cfargument name="value" type="any" required="yes" hint="The value to set">
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
	<cfset this.currentLink.value = ARGUMENTS.value>
</cffunction>

<cffunction name="Next" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Next value, if it exists, moves iterator">
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
  <cfif NOT HasNext()>
		<cfthrow message="Overflow">
	</cfif>          
  <cfset this.currentLink = this.currentLink.GetNext()>
	<cfreturn this.currentLink.value>
</cffunction>

<cffunction name="Prev" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Previous value, if it exists, moves iterator backwards">
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
  <cfif NOT HasPrev()>
		<cfthrow message="Overflow">
	</cfif>          
  <cfset this.currentLink = this.currentLink.GetPrev()>
	<cfreturn this.currentLink.value>
</cffunction>

<cffunction name="NextValue" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Next value or '', doesn't move iterator">
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
  <cfif HasNext()>
		<cfreturn this.currentLink.GetNext().value>
	</cfif>          
	<cfreturn ''>
</cffunction>

<cffunction name="PrevValue" 
						returntype="any" 
            access="public" 
            output="false" 
            description="Previous value or '', doesn't move iterator">
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
  <cfif HasPrev()>
		<cfreturn this.currentLink.GetPrev().value>
	</cfif>          
	<cfreturn ''>
</cffunction>

<cffunction name="HasNext"
						returntype="boolean"
            access="public"
            output="no"
            description="True if there is no next link">
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
	<cfreturn this.currentLink.HasNext()>
</cffunction>

<cffunction name="HasPrev"
						returntype="boolean"
            access="public"
            output="no"
            description="True if there is no prev link">
  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
	<cfreturn this.currentLink.HasPrev()>
</cffunction>

<!---
Set iterator to First or Last, then call this with
either loop(true) or loop(false) respectivly --->
<cfset variables._loop_first = true>
<cffunction name="Loop"
						returntype="boolean"
            access="public"
            output="no"
            description="cfloop condition=iterator.loop(forward=true or false)'">
	<cfargument name="forward" type="boolean" required="no" default="true" hint="Loop forward?">
  <cfset var result = true>

  <cfset ValidateIterator()>  <!--- throws if Init() hasn't been called --->
  <!--- If first time through, don't advance iterator --->  
	<cfif NOT variables._loop_first>
    <cfif forward>
        <cfif HasNext()>
          <cfset Next()>
        <cfelse>
          <cfset result = false>
        </cfif>
    <cfelse>
        <cfif HasPrev()>
          <cfset Prev()>
        <cfelse>
          <cfset result = false>
        </cfif>
    </cfif>
  </cfif>
  
	<cfset variables._loop_first = NOT result>
	<cfreturn result>  
</cffunction>

</cfcomponent>
