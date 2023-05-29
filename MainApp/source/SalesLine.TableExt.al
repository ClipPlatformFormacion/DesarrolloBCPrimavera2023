tableextension 50100 "CLIP Sales Line" extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = if (Type = const("CLIP Course")) "CLIP Course"."No.";
        }

        // modify(Quantity)
        // {
        //     trigger OnAfterValidate()
        //     var
        //         CourseSalesManagement: Codeunit "CLIP Course - Sales Management";
        //     begin
        //         CourseSalesManagement.MiComprobacion();
        //     end;
        // }
        field(50100; "CLIP Course Edition"; Code[20])
        {
            Caption = 'Course Edition', comment = 'ESP="Edición curso"';
            DataClassification = CustomerContent;
            TableRelation = "CLIP Course Edition".Edition where("Course No." = field("No."));

            // trigger OnValidate()
            // var
            //     CourseSalesManagement: Codeunit "CLIP Course - Sales Management";
            // begin
            //     CourseSalesManagement.MiComprobacion();
            // end;
        }
    }


}