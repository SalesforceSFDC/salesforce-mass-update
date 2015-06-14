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
