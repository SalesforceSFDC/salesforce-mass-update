# salesforce-mass-update
Mass update utility that works with field sets.
Class:
```apex
public class OpportunityMassUpdate {
    public Opportunity[] lstOpportunities {get;private set;}
    public Opportunity dummyOpportunity {get;set;}
    ApexPages.StandardSetController setCon;
    public OpportunityMassUpdate(ApexPages.StandardSetController controller)
    {
        setCon = controller;
        dummyOpportunity = new Opportunity ();
        String queryFields = '';
        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.updateAll.getFields()) {
            if(queryFields.length() > 0) {
                queryFields += ', ';
            }
            queryFields += f.getFieldPath();
        }
        Opportunity[] IDs = setCon.getSelected();
        this.lstOpportunities = Database.query(
            ' SELECT name, ' +
                queryFields +
            ' FROM ' +
                ' Opportunity ' +
            ' WHERE ' +
                ' name != null and id in:IDs ' +
            ' order by name asc');
    }

    public PageReference mySave() { 
        try{ 
            update lstOpportunities;
        } catch (system.Dmlexception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+string.valueOf(e));
            ApexPages.addMessage(myMsg);
        }
        PageReference pageRef = new PageReference( '/' + ApexPages.currentPage().getParameters().get('id')); //redirects back to id
        return pageRef ; 
    }
}

```


Page: 
```html
<apex:page standardController="Opportunity" recordSetVar="opps" extensions="OpportunityMassUpdate">
    <apex:includeScript value="//ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js" />
    <script type="text/javascript">
    j$ = jQuery.noConflict();
    </script>
    <apex:form >        
        <apex:pageBlock id="block">
            <apex:pageBlockTable id="table" var="opp" value="{!dummyOpportunity}">
                <apex:column headerValue="Unique Identifier" value="{!opp.Name}" />
                <apex:repeat var="f" value="{!$ObjectType.Opportunity.FieldSets.updateAll}">
                    <apex:column headerValue="{!f.label}">
                        <apex:inputField value="{!opp[f]}" onchange="if('{!f.type}'==='boolean'){
                                                                    j$('.{!f.fieldPath}').prop('checked',j$(this).prop('checked'))
                                                                    } else {
                                                                    j$('.{!f.fieldPath}').val(j$(this).val())
                                                                    }"  />
                    </apex:column>
                </apex:repeat>
            </apex:pageBlockTable> 
        </apex:pageBlock>        
    </apex:form> 

    <apex:form >        
        <apex:pageBlock id="block">
            <apex:pageBlockTable id="table" var="opp" value="{!lstOpportunities}">
                <apex:column headerValue="Unique Identifier" value="{!opp.Name}" />
                <apex:repeat var="f" value="{!$ObjectType.Opportunity.FieldSets.updateAll}">
                    <apex:column headerValue="{!f.label}">
                        <apex:inputField value="{!opp[f]}" styleClass="{!f.fieldPath}" />
                    </apex:column>
                </apex:repeat>
            </apex:pageBlockTable>
            <apex:pageBlockButtons >        
                <apex:commandButton value="Save" action="{!mySave}" />        
            </apex:pageBlockButtons>
        </apex:pageBlock>        
    </apex:form> 
</apex:page>

```

![Use demonstration](http://i.imgur.com/zurchRP.gif)

# Update:

Added Deploy to Salesforce button. Changed example to work with Opportunities. Note, you'll still need to:
  * Create UpdateAll field set on Opportunity (don't add Name field though)
  * After deploy, create a list button pointing to the page
  * Add button to page layouts

Previous version explains how to integrate with custom objects:
Replace *contract__c* with whatever sObject you decided to use.

Replace *updateAll* field set name with whatever field set name you've set up.

Class:
```Apex
public class updateContracts {
    public List<contract__c> meters { get; private set; }
    public contract__c oneMeter {get;set;}
        
    ApexPages.StandardSetController setCon;
    public updateContracts(ApexPages.StandardSetController controller)
    {
        setCon = controller;
        oneMeter = new contract__c ();
        String queryFields = '';
        for(Schema.FieldSetMember f : SObjectType.contract__c.FieldSets.updateAll.getFields()) {
            if(queryFields.length() > 0) {
                queryFields += ', ';
            }
            queryFields += f.getFieldPath();
        }
        contract__c[] meterIDs = setCon.getSelected();
        this.meters = Database.query(
            ' SELECT name, ' +
                queryFields +
            ' FROM ' +
                ' contract__c ' +
            ' WHERE ' +
                ' name != null and id in:meterIDs ' +
            ' order by name asc');
    }

    public PageReference mySave() { 
        try{ 
            update meters;
        } catch (system.Dmlexception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+string.valueOf(e));
            ApexPages.addMessage(myMsg);
        }
        PageReference pageRef = new PageReference( '/' + ApexPages.currentPage().getParameters().get('id')); //redirects back to id
        return pageRef ; 
    }
}

```

Page:
```html
<apex:page standardController="Contract__c" recordSetVar="accounts2" extensions="updateContracts">
       <apex:includeScript value="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js" />
    <script type="text/javascript">
    j$ = jQuery.noConflict();
    </script>
    <apex:form >        
        <apex:pageBlock id="block">
            <apex:pageBlockTable id="table" var="met" value="{!oneMeter}">
                <apex:column headerValue="Unique Identifier" value="{!met.Name}" />
                <apex:repeat var="f" value="{!$ObjectType.Contract__c.FieldSets.updateAll}">
                    <apex:column headerValue="{!f.label}">
                        <apex:inputField value="{!met[f]}" onchange="if('{!f.type}'==='boolean'){
                                                                    j$('.{!f.fieldPath}').prop('checked',j$(this).prop('checked'))
                                                                    } else {
                                                                    j$('.{!f.fieldPath}').val(j$(this).val())
                                                                    }"  />
                    </apex:column>
                </apex:repeat>
            </apex:pageBlockTable> 
        </apex:pageBlock>        
    </apex:form> 

    <apex:form >        
        <apex:pageBlock id="block">
            <apex:pageBlockTable id="table" var="meter" value="{!meters}">
                <apex:column headerValue="Unique Identifier" value="{!meter.Name}" />
                <apex:repeat var="f" value="{!$ObjectType.Contract__c.FieldSets.updateAll}">
                    <apex:column headerValue="{!f.label}">
                        <apex:inputField value="{!meter[f]}" styleClass="{!f.fieldPath}" />
                    </apex:column>
                </apex:repeat>
            </apex:pageBlockTable>
            <apex:pageBlockButtons >        
                <apex:commandButton value="Save" action="{!mySave}" />        
            </apex:pageBlockButtons>
        </apex:pageBlock>        
    </apex:form> 
</apex:page>

```
