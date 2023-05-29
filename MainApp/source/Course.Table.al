table 50100 "CLIP Course"
{
    Caption = 'Course', Comment = 'ESP="Curso"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';

            trigger OnValidate()
            var
                ResSetup: Record "CLIP Courses Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "No." <> xRec."No." then begin
                    ResSetup.Get();
                    NoSeriesMgt.TestManual(ResSetup."Course Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(3; "Content Description"; Text[2048])
        {
            Caption = 'Content Description', Comment = 'ESP="Descripción temario"';
        }
        field(4; "Duration (hours)"; Integer)
        {
            Caption = 'Duration (hours)', Comment = 'ESP="Duración (horas)"';
            BlankZero = true;
        }
        field(5; Price; Decimal)
        {
            Caption = 'Price', Comment = 'ESP="Precio"';
            BlankZero = true;
        }
        field(6; "Type (Option)"; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
            OptionMembers = " ","Instructor-Lead","Video Tutorial";
            OptionCaption = ' ,Instructor-Lead,Video Tutorial', Comment = 'ESP=" ,Guiado por profesor,Vídeo tutorial"';
        }
        field(8; Type; Enum "CLIP Course Type")
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
        }
        field(7; "Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'ESP="Cód. idioma"';
            TableRelation = Language;
            ValidateTableRelation = false;
        }
        field(51; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group', Comment = 'ESP="Grupo contable prod. gen."';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            var
                GenProductPostingGroup: Record "Gen. Product Posting Group";
            begin
                if xRec."Gen. Prod. Posting Group" <> Rec."Gen. Prod. Posting Group" then
                    if GenProductPostingGroup.ValidateVatProdPostingGroup(GenProductPostingGroup, "Gen. Prod. Posting Group") then
                        Rec.Validate("VAT Prod. Posting Group", GenProductPostingGroup."Def. VAT Prod. Posting Group");
            end;
        }
        field(58; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group', Comment = 'ESP="Grupo contable IVA prod."';
            TableRelation = "VAT Product Posting Group";
        }
        field(56; "No. Series"; Code[20])
        {
            Caption = 'No. Series', Comment = 'ESP="Nº Serie"';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    trigger OnInsert()
    var
        CoursesSetup: Record "CLIP Courses Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            CoursesSetup.Get();
            CoursesSetup.TestField("Course Nos.");
            NoSeriesManagement.InitSeries(CoursesSetup."Course Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    procedure AssistEdit(OldCourse: Record "CLIP Course") Result: Boolean
    var
        CoursesSetup: Record "CLIP Courses Setup";
        Course: Record "CLIP Course";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    // IsHandled: Boolean;
    begin
        // IsHandled := false;
        // OnBeforeAssistEdit(Rec, OldRes, IsHandled, Result);
        // if IsHandled then
        //     exit;

        Course := Rec;
        CoursesSetup.Get();
        CoursesSetup.TestField("Course Nos.");
        if NoSeriesManagement.SelectSeries(CoursesSetup."Course Nos.", OldCourse."No. Series", Course."No. Series") then begin
            CoursesSetup.Get();
            CoursesSetup.TestField("Course Nos.");
            NoSeriesManagement.SetSeries(Course."No.");
            Rec := Course;
            exit(true);
        end;
    end;
}