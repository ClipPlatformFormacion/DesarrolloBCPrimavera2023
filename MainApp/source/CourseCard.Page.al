page 50101 "CLIP Course Card"
{
    Caption = 'Course Card', Comment = 'ESP="Ficha curso"';
    PageType = Card;
    UsageCategory = None;
    SourceTable = "CLIP Course";

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
            part(CourseEditions; "CLIP Course Editions FactBox")
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
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group") { ApplicationArea = All; }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group") { ApplicationArea = All; }
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
            action("Ledger E&ntries")
            {
                ApplicationArea = All;
                Caption = 'Ledger E&ntries', Comment = 'ESP="Movimientos"';
                Image = ResourceLedger;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "CLIP Course Ledger Entries";
                RunPageLink = "Course No." = field("No.");
                ShortCutKey = 'Ctrl+F7';
                ToolTip = 'View the history of transactions that have been posted for the selected record.';
            }
        }
    }
}