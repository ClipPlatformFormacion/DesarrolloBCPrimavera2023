pageextension 50110 "CLIP SalesOrderArchiveSubform" extends "Sales Order Archive Subform"
{
    layout
    {
        addafter("No.")
        {
            field("CLIP Course Edition1"; Rec."CLIP Course Edition")
            {
                ApplicationArea = All;
            }
        }
    }
}