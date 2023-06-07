xmlport 50100 "CLIP Export Sales Orders"
{
    Direction = Export;

    schema
    {
        textelement(Root)
        {
            tableelement(SalesHeader; "Sales Header")
            {
                textelement(UnTextElement)
                {
                    trigger OnBeforePassVariable()
                    begin
                        UnTextElement := SalesHeader."Sell-to Customer Name";
                    end;
                }
                fieldelement(Customer; SalesHeader."Sell-to Customer No.") { }
                fieldelement(No; SalesHeader."No.") { }
                fieldelement(Date; SalesHeader."Order Date") { }

                tableelement(SalesLine; "Sales Line")
                {
                    LinkTable = SalesHeader;
                    LinkFields = "Document Type" = field("Document Type"), "Document No." = field("No.");

                    fieldelement(Type; SalesLine.Type) { }
                    fieldelement(No; SalesLine."No.") { }
                    fieldelement(Quantity; SalesLine.Quantity) { }
                }
            }
        }
    }
}