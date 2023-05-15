pageextension 50103 "CLIP Sales Cr. Memo Subform" extends "Sales Cr. Memo Subform"
{
    layout
    {
        addafter("No.")
        {
            field("CLIP Course Edition1"; Rec."CLIP Course Edition")
            {
                ApplicationArea = All;
                Enabled = MiVariable;
            }
        }
        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                MiVariable := Rec.Type = Rec.Type::"CLIP Course";
            end;
        }
    }

    trigger OnAfterGetRecord()
    begin
        MiVariable := Rec.Type = Rec.Type::"CLIP Course";

        // if Rec.Type = Rec.Type::"CLIP Course" then
        //     MiVariable := true
        // else
        //     MiVariable := false;
    end;

    var
        MiVariable: Boolean;
}