<!---
This CFC is released under the Apache 2.0 License
For more info, read: http://www.apache.org/licenses/LICENSE-2.0

Author Chuck Savage
© Copyright SeaRisen LLC 2009
Created November of 2009

Notes:
You'll need to do a replaceAll on mg.model.linkedlist.link for the location
you have this.

See the documentation at: 
http://linkedlist.riaforge.org/wiki/index.cfm/Link_API

--->
<cfcomponent name="Link" output="false">  

	<cfscript>
  this.value = ""; // <!--- use this, so don't have to use SetValue() or GetValue() --->
  variables.prev = "";
	variables.next = "";
  </cfscript>

<cffunction name="Init" returntype="any" access="public" output="false"> 
  <cfargument name="value" type="any" required="yes">
	<cfargument name="prev" type="mg.model.linkedlist.link" required="no" default="">
	<cfargument name="next" type="mg.model.linkedlist.link" required="no" default="">
	<cfset this.value = ARGUMENTS.value>
	<cfset variables.prev = ARGUMENTS.prev>
  <cfset variables.next = ARGUMENTS.next>
	<cfreturn this />  
</cffunction>  

<cffunction name="GetValue" returntype="any" access="public" output="no">
  <cfreturn this.value>
</cffunction>

<cffunction name="SetValue" returntype="void" access="public" output="no">
  <cfargument name="value" type="any" required="yes">
  <cfset this.value = ARGUMENTS.value>
</cffunction>

<cffunction name="ClearPrev" 
						returntype="void" 
            access="public" 
            output="no">
  <cfset variables.prev="">
</cffunction>

<cffunction name="GetPrev" 
						returntype="mg.model.linkedlist.link" 
            access="public" 
            output="no">
  <cfreturn variables.prev>
</cffunction>

<cffunction name="HasPrev"
						returntype="boolean"
            access="public"
            output="no">
	<cfreturn NOT IsSimpleValue( variables.prev )>            
</cffunction>

<cffunction name="SetPrev" returntype="void" access="public" output="no">
	<cfargument name="prev" type="mg.model.linkedlist.link" required="no" default="">
  <cfset variables.prev = ARGUMENTS.prev>
</cffunction>

<cffunction name="ClearNext" 
						returntype="void" 
            access="public" 
            output="no">
  <cfset variables.next="">
</cffunction>

<cffunction name="GetNext" 
						returntype="mg.model.linkedlist.link" 
            access="public" 
            output="no">
  <cfreturn variables.next>
</cffunction>

<cffunction name="HasNext"
						returntype="boolean"
            access="public"
            output="no">
	<cfreturn NOT IsSimpleValue( variables.next )>            
</cffunction>

<cffunction name="SetNext" returntype="void" access="public" output="no">
	<cfargument name="next" type="mg.model.linkedlist.link" required="no" default="">
  <cfset variables.next = ARGUMENTS.next>
</cffunction>

</cfcomponent>
