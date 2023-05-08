page 50101 "Course Card"
{
    CaptionML = ENU = 'Course Card', ESP = 'Ficha curso';
    PageType = Card;
    UsageCategory = None;
    SourceTable = Course;

    layout
    {
        area(Content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'contextual help', ESP = 'ayuda contextual';

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
                CaptionML = ENU = 'Training', ESP = 'Formación';
                field(Type; Rec.Type) { ApplicationArea = All; }
                field("Duration (hours)"; Rec."Duration (hours)") { ApplicationArea = All; }
                field("Language Code"; Rec."Language Code") { ApplicationArea = All; }
                field("Content Description"; Rec."Content Description") { ApplicationArea = All; }
            }
            group(Invoicing)
            {
                CaptionML = ENU = 'Invoicing', ESP = 'Facturación';
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
                CaptionML = ENU = 'Editions', ESP = 'Ediciones';
                Image = CodesList;
                RunObject = page "Course Editions";
                RunPageLink = "Course No." = field("No.");
            }
        }
    }
}