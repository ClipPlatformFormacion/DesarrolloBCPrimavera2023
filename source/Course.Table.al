table 50100 "Course"
{
    CaptionML = ENU = 'Course', ESP = 'Curso', ESM = 'Curso';
    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'Nº';

            trigger OnValidate()
            var
                ResSetup: Record "Courses Setup";
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
            CaptionML = ENU = 'Name', ESP = 'Nombre';
        }
        field(3; "Content Description"; Text[2048])
        {
            CaptionML = ENU = 'Content Description', ESP = 'Descripción temario';
        }
        field(4; "Duration (hours)"; Integer)
        {
            CaptionML = ENU = 'Duration (hours)', ESP = 'Duración (horas)';
        }
        field(5; Price; Decimal)
        {
            CaptionML = ENU = 'Price', ESP = 'Precio';
        }
        field(6; "Type (Option)"; Option)
        {
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionMembers = " ","Instructor-Lead","Video Tutorial";
            OptionCaptionML = ENU = ' ,Instructor-Lead,Video Tutorial', ESP = ' ,Guiado por profesor,Vídeo tutorial';
        }
        field(8; Type; Enum "Course Type")
        {
            CaptionML = ENU = 'Type', ESP = 'Tipo';
        }
        field(7; "Language Code"; Code[10])
        {
            CaptionML = ENU = 'Language Code', ESP = 'Cód. idioma';
            TableRelation = Language;
        }
        field(56; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', ESP = 'Nº Serie';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    trigger OnInsert()
    var
        CoursesSetup: Record "Courses Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            CoursesSetup.Get();
            CoursesSetup.TestField("Course Nos.");
            NoSeriesManagement.InitSeries(CoursesSetup."Course Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    procedure AssistEdit(OldCourse: Record Course) Result: Boolean
    var
        CoursesSetup: Record "Courses Setup";
        Course: Record Course;
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