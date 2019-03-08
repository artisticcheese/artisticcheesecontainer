<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Links.aspx.cs" Inherits="Links" Title="Untitled Page" %>
<%@ Import Namespace="System.Data" %>
<h2>Links</h2>
        <asp:DataList id="lstLinks" runat="server"
          BorderColor="black"
          BorderWidth="1"
          GridLines="Both"
          CellPadding="4"
          CellSpacing="0"
          >
            <HeaderTemplate>
                <table>
            </HeaderTemplate>

            <ItemTemplate>
                <tr>
                    <td><a href="<%# ((DictionaryEntry)Container.DataItem).Value %>"><%# ((DictionaryEntry)Container.DataItem).Key %></a></td> 
                </tr>
            </ItemTemplate>
        
            <FooterTemplate>
            </table>
            </FooterTemplate>

        </asp:DataList>
</asp:Content>

