pageextension 50106 "CLIP Posted Sales Shpt.Subform" extends "Posted Sales Shpt. Subform"
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