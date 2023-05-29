page 50103 "CLIP Course Editions"
{
    Caption = 'Course Editions', Comment = 'ESP="Ediciones cursos"';
    PageType = List;
    UsageCategory = None;
    SourceTable = "CLIP Course Edition";
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
                field("Sales (Qty.)"; Rec."Sales (Qty.)") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Ledger E&ntries")
            {
                ApplicationArea = All;
                Caption = 'Ledger E&ntries', Comment = 'ESP="Movimientos"';
                Image = ResourceLedger;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "CLIP Course Ledger Entries";
                RunPageLink = "Course No." = field("Course No."), "Course Edition" = field(Edition);
                ShortCutKey = 'Ctrl+F7';
                ToolTip = 'View the history of transactions that have been posted for the selected record.';
            }
        }
    }
}