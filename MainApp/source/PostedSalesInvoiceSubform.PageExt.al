pageextension 50107 "CLIP PostedSalesInvoiceSubform" extends "Posted Sales Invoice Subform"
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