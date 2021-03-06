Class Example.StoredData Extends %Persistent
{

Property StringData As %String;

Property StringSQLComputed As %String [ Calculated, SqlComputeCode = {set {*} = "DoubledValue="_($Piece({StringData},"=",2)*2)}, SqlComputed ];

ClassMethod AddRecords(records As %Integer = 10) As %Status
{
    set counter=0
    while counter < records {
        set counter=$I(counter)
        set obj=..%New()
        set obj.StringData="Value="_counter
        do obj.%Save()
    }
}

ClassMethod DisplayAllRecords() As %Status
{
    set query = ##class(%SQL.Statement).%New()
    set status= query.%PrepareClassQuery("Example.StoredData","Extent")
    set rset=query.%Execute()

    while (rset.%Next()) {
    
    set obj=..%OpenId(rset.%Get("ID"))
    write "%ID=",obj.%Id(),", StringData=",obj.StringData," StringSQLComputed=",obj.StringSQLComputed,!
 }
}

ClassMethod DeleteAllRecords() As %Status
{
    do ..%KillExtent()
}

/// slow but universal method 
/// it could be slow cause %OpenId opens all the properties of instance in memory
ClassMethod GetPropertyForID(stId As %Integer) As %String
{
    set obj=..%OpenId(stId)
    return obj.StringData
}

/// Fast method, because gets data from Global
/// Doesn't work for calculated and transient properties
ClassMethod GetStoredPropertyForID(stId As %Integer) As %String
{
        return ##class(Example.StoredData).StringDataGetStored(stId)
}

ClassMethod GetColumnForID(stId As %Integer) As %String
{
    &sql(select StringData into :sd from Example.StoredData where id = :stId)
    return sd
}

Storage Default
{
<Data name="StoredDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StringData</Value>
</Value>
</Data>
<DataLocation>^Example.StoredDataD</DataLocation>
<DefaultData>StoredDataDefaultData</DefaultData>
<IdLocation>^Example.StoredDataD</IdLocation>
<IndexLocation>^Example.StoredDataI</IndexLocation>
<StreamLocation>^Example.StoredDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
