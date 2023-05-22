codeunit 50140 "CLIP Course Test"
{
    Subtype = Test;

    [Test]
    procedure Test000()
    begin

    end;

    [Test]
    procedure Test001()
    var
        CLIPMin: Codeunit "CLIP Min";
        Value1, Value2 : Decimal;
        Result: Decimal;
    begin
        // [Scenario] Una función llamada GetMin devuelve el mínimo de 2 valores numéricos

        // [Given] 2 valores numéricos (4 y 6)
        Value1 := 4;
        Value2 := 6;

        // [When] al llamar a la función GetMin
        Result := CLIPMin.GetMin(Value1, Value2);

        // [Then] El resultado es 4
        if Result <> Value1 then
            Error('El resultado no es el correcto');
    end;

    [Test]
    procedure Test002()
    var
        CLIPMin: Codeunit "CLIP Min";
        LibraryAssert: Codeunit "Library Assert";
        Value1, Value2 : Decimal;
        Result: Decimal;
    begin
        // [Scenario] Una función llamada GetMin devuelve el mínimo de 2 valores numéricos

        // [Given] 2 valores numéricos (4 y 6)
        Value1 := 6;
        Value2 := 4;

        // [When] al llamar a la función GetMin
        Result := CLIPMin.GetMin(Value1, Value2);

        // [Then] El resultado es 4
        LibraryAssert.AreEqual(Value2, Result, 'El resultado no es el correcto');
    end;

    [Test]
    procedure CourseSalesTest001()
    var
        Course: Record "CLIP Course";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "CLIP Library - Course";
    begin
        // [Scenario] Cuando se selecciona un curso en una línea de un documento de venta,
        //              el sistema rellena la información relacionada con el curso

        // [Given] Un curso y un documento de venta
        LibraryCourse.CreateCourse(Course);

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);

        // [When] seleccionamos el curso en la línea de venta
        SalesLine.Validate(Type, "Sales Line Type"::"CLIP Course");
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Modify();

        // [Then] la línea de venta tiene Descripción, grupos contables y precio correctos
        LibraryAssert.AreEqual(Course.Name, SalesLine.Description, 'La descripción no es correcta');
        LibraryAssert.AreEqual(Course.Price, SalesLine."Unit Price", 'El precio no es correcto');
        LibraryAssert.AreEqual(Course."Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group", 'El grupo contable no es correcto');
        LibraryAssert.AreEqual(Course."VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group", 'El grupo contable no es correcto');
    end;

    [Test]
    procedure EditionIsFilledInPostedDocuments()
    var
        Course: Record "CLIP Course";
        CourseEdition: Record "CLIP Course Edition";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "CLIP Library - Course";
    begin
        // [Scenario] Cuando se registra un documento de venta, la información de la edición de curso seleccionada por el usuario
        //            queda guardada en los documentos registrados (albarán)

        // [Given] Un curso con una edición y un documento de venta para el curso y edición
        LibraryCourse.CreateCourse(Course);
        CourseEdition := LibraryCourse.CreateEdition(Course."No.");

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, "Sales Line Type"::"CLIP Course");
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("CLIP Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Modify();

        // [When] se registra el albarán de venta
        LibrarySales.PostSalesDocument(SalesHeader, true, false);

        // [Then] la edición en el albarán es la correcta
        SalesShipmentLine.SetRange("Order No.", SalesLine."Document No.");
        SalesShipmentLine.SetRange("Order Line No.", SalesLine."Line No.");
        SalesShipmentLine.FindLast();

        LibraryAssert.AreEqual(SalesLine."CLIP Course Edition", SalesShipmentLine."CLIP Course Edition", 'La edición en el albarán no es correcta');
    end;
}