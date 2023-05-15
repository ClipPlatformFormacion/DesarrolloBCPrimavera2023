pageextension 50100 "CLIP Sales Order Subform" extends "Sales Order Subform"
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
        // addfirst(Control1)
        // {
        //     field("CLIP Course Edition2"; Rec."CLIP Course Edition")
        //     {
        //         ApplicationArea = All;
        //     }
        // }
        moveafter(Quantity; "Location Code")
        modify(Description)
        {
            Caption = 'The Description', comment = 'ESP="La Descripción"';
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
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