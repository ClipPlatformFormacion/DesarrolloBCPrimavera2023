reportextension 50100 "CLIP Standard Sales - Invoice" extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Line)
        {
            column(CLIP_Course_Edition; "CLIP Course Edition") { }
        }
    }

    requestpage
    {
        layout
        {

        }
    }

    rendering
    {
        layout("CLIP ExtendedLayout")
        {
            Type = RDLC;
            LayoutFile = './source/ExtendedStandardSalesInvoice.rdl';
        }
    }
}