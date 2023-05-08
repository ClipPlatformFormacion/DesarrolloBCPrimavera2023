page 50103 "Course Editions"
{
    Caption = 'Course Editions', Comment = 'ESP="Ediciones cursos"';
    PageType = List;
    UsageCategory = None;
    SourceTable = "Course Edition";
    DataCaptionFields = "Course No.";

    layout
    {
        area(Content)
        {
            repeater(RepeaterControl)
            {
                field("Course No."; Rec."Course No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Edition; Rec.Edition) { ApplicationArea = All; }
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; }
                field("Max. Students"; Rec."Max. Students") { ApplicationArea = All; }
            }
        }
    }
}