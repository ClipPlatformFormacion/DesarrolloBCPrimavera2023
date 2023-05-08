page 50100 "CLIP Course List"
{
    Caption = 'Courses', Comment = 'ESP="Cursos"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CLIP Course";
    Editable = false;
    CardPageId = "CLIP Course Card";

    layout
    {
        area(Content)
        {
            repeater(RepeaterControl)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field("Duration (hours)"; Rec."Duration (hours)") { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field("Language Code"; Rec."Language Code") { ApplicationArea = All; }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }

        area(FactBoxes)
        {
            part(CourseEditions; "CLIP Course Editions FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Course No." = field("No.");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Editions)
            {
                ApplicationArea = All;
                Caption = 'Editions', Comment = 'ESP="Ediciones"';
                Image = CodesList;
                RunObject = page "CLIP Course Editions";
                RunPageLink = "Course No." = field("No.");
            }
        }
    }
}