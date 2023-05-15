pageextension 50109 "CLIP PostedReturnReceiptSubfor" extends "Posted Return Receipt Subform"
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