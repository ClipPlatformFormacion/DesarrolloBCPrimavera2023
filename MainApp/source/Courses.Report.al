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
            column(CourseNo; Course."No.") { }
            column(CourseName; Course.Name) { }
            column(CourseDurationHours; "Duration (hours)") { }

            dataitem(CourseEdition; "CLIP Course Edition")
            {
                DataItemTableView = sorting("Course No.", Edition) order(ascending);
                DataItemLinkReference = Course;
                DataItemLink = "Course No." = field("No.");

                column(Edition; CourseEdition.Edition) { }
                column(EditionMaxStudents; CourseEdition."Max. Students") { }
                column(EditionSalesQty; CourseEdition."Sales (Qty.)") { }

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

    var
        Counter: Integer;
        CounterEdition: Integer;
        ShowMessage: Boolean;
}