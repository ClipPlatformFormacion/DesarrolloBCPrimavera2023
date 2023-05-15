pageextension 50108 "CLIP PostedSalesCr.MemoSubform" extends "Posted Sales Cr. Memo Subform"
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