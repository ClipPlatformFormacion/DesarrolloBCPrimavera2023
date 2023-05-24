codeunit 50100 "CLIP Course - Sales Management"
{
    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnBeforeIncludeOption', '', false, false)]
    local procedure OnBeforeIncludeOption(OptionLookupBuffer: Record "Option Lookup Buffer" temporary; LookupType: Option; Option: Integer; var Handled: Boolean; var Result: Boolean; RecRef: RecordRef);
    begin
        if Option = Enum::"Sales Line Type"::"CLIP Course".AsInteger() then begin
            Handled := true;
            Result := true;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignFieldsForNo', '', false, false)]
    local procedure CopyFromCourse(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        Course: Record "CLIP Course";
    begin
        if SalesLine.Type <> SalesLine.Type::"CLIP Course" then
            exit;

        Course.Get(SalesLine."No.");

        Course.TestField("Gen. Prod. Posting Group");
        SalesLine.Description := Course.Name;
        SalesLine."Gen. Prod. Posting Group" := Course."Gen. Prod. Posting Group";
        SalesLine."VAT Prod. Posting Group" := Course."VAT Prod. Posting Group";
        SalesLine."Unit Price" := Course.Price;
        SalesLine."Allow Item Charge Assignment" := false;
        OnAfterAssignCourseValues(SalesLine, Course, SalesHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignCourseValues(var SalesLine: Record "Sales Line"; Course: Record "CLIP Course"; SalesHeader: Record "Sales Header")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforePostSalesLine', '', false, false)]
    local procedure OnPostSalesLineOnBeforePostSalesLine(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandled: Boolean);
    begin
        if SalesLine.Type <> SalesLine.Type::"CLIP Course" then
            exit;

        PostCourseJournalLine(SalesHeader, SalesLine, GenJnlLineDocNo, GenJnlLineExtDocNo, GenJnlLineDocType, SrcCode);
    end;

    local procedure PostCourseJournalLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10])
    var
        CourseJournalLine: Record "CLIP Course Journal Line";
        CourseJnlPostLine: Codeunit "CLIP Course Jnl.-Post Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePostCourseJournalLine(SalesHeader, SalesLine, IsHandled, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, CourseJnlPostLine);
        if IsHandled then
            exit;

        if SalesLine."Qty. to Invoice" = 0 then
            exit;

        CourseJournalLine.Init();
        CourseJournalLine.CopyFromSalesHeader(SalesHeader);
        CourseJournalLine.CopyDocumentFields(GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, SalesHeader."Posting No. Series");
        CourseJournalLine.CopyFromSalesLine(SalesLine);
        OnPostCourseJournalLineOnAfterInit(CourseJournalLine, SalesLine);

        CourseJnlPostLine.RunWithCheck(CourseJournalLine);

        OnAfterPostCourseJournalLine(SalesHeader, SalesLine, CourseJournalLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostCourseJournalLineOnAfterInit(var CourseJournalLine: Record "CLIP Course Journal Line"; var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostCourseJournalLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean; DocNo: Code[20]; ExtDocNo: Code[35]; SourceCode: Code[10]; var CourseJnlPostLine: Codeunit "CLIP Course Jnl.-Post Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostCourseJournalLine(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; CourseJournalLine: Record "CLIP Course Journal Line")
    begin
    end;
}