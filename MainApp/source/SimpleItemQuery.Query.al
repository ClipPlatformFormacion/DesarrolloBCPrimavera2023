query 50100 "CLIP Simple Item Query"
{
    QueryType = Normal;

    elements
    {
        dataitem(Item; Item)
        {
            DataItemTableFilter = "Replenishment System" = const(Purchase);
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Base_Unit_of_Measure; "Base Unit of Measure") { }
            column(Unit_Cost; "Unit Cost")
            {
                ColumnFilter = Unit_Cost = filter('<>0');
            }
            filter(Vendor_No_; "Vendor No.") { }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = Item."Vendor No.";
                SqlJoinType = InnerJoin;
                column(Name; Name) { }
                column(City; City) { }
            }
        }
    }
}