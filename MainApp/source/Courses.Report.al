report 50100 "CLIP Courses"
{
    Caption = 'Courses List', comment = 'ESP="Listado de Cursos"';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = MainRDLCLayout;

    dataset
    {
        dataitem(Course; "CLIP Course")
        {
            RequestFilterFields = "No.", "Language Code";

            column(ReportCaption; ReportCaptionLbl) { }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName()) { }
            column(TableFilters; Course.TableCaption() + ': ' + CourseFilter) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(CourseNo; Course."No.") { IncludeCaption = true; }
            column(CourseName; Course.Name) { IncludeCaption = true; }
            column(CourseDurationHours; "Duration (hours)") { IncludeCaption = true; }

            dataitem(CourseEdition; "CLIP Course Edition")
            {
                DataItemTableView = sorting("Course No.", Edition) order(ascending);
                DataItemLinkReference = Course;
                DataItemLink = "Course No." = field("No.");

                column(Edition; CourseEdition.Edition) { IncludeCaption = true; }
                column(EditionMaxStudents; CourseEdition."Max. Students") { IncludeCaption = true; }
                column(EditionSalesQty; CourseEdition."Sales (Qty.)") { IncludeCaption = true; }

                trigger OnAfterGetRecord()
                begin
                    Counter += 1;
                end;

                trigger OnPostDataItem()
                begin
                    CounterEdition += 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Counter += 1;
            end;

            trigger OnPostDataItem()
            begin
                if ShowMessage then begin
                    Message('Cursos: ' + Format(Counter));
                    Message('Ediciones: ' + Format(CounterEdition));
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';
                    field(ShowMessageControl; ShowMessage)
                    {
                        Caption = 'Show Message', comment = 'ESP="Mostrar Message"';
                        ApplicationArea = All;
                    }
                }
            }
        }

        trigger OnInit()
        begin
            ShowMessage := true;
        end;
    }

    rendering
    {
        layout(MainRDLCLayout)
        {
            Type = RDLC;
            LayoutFile = './source/Courses_MainRdlcLayout.rdl';
        }
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        CourseFilter := FormatDocument.GetRecordFiltersWithCaptions(Course);
    end;

    var
        Counter: Integer;
        CounterEdition: Integer;
        ShowMessage: Boolean;
        ReportCaptionLbl: Label 'Course List', Comment = 'ESP="Listado de cursos"';
        CurrReport_PAGENOCaptionLbl: Label 'Page', Comment = 'ESP="Pág."';
        CourseFilter: Text;
}