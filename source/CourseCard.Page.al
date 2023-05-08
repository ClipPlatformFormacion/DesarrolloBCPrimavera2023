page 50101 "Course Card"
{
    Caption = 'Course Card', Comment = 'ESP="Ficha curso"';
    PageType = Card;
    UsageCategory = None;
    SourceTable = Course;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'contextual help', Comment = 'ESP="ayuda contextual"';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name) { ApplicationArea = All; }
            }
            part(CourseEditions; "Course Editions FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Course No." = field("No.");
            }

            group(Training)
            {
                Caption = 'Training', Comment = 'ESP="Formación"';
                field(Type; Rec.Type) { ApplicationArea = All; }
                field("Duration (hours)"; Rec."Duration (hours)") { ApplicationArea = All; }
                field("Language Code"; Rec."Language Code") { ApplicationArea = All; }
                field("Content Description"; Rec."Content Description") { ApplicationArea = All; }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing', Comment = 'ESP="Facturación"';
                field(Price; Rec.Price) { ApplicationArea = All; }
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
                RunObject = page "Course Editions";
                RunPageLink = "Course No." = field("No.");
            }
        }
    }
}