using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

// NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service" in code, svc and config file together.
public class Service : IService
{
   
    public string GetPI(string value)
	{
// return CalculatePi(Int32.Parse(value));
        return (CalculatePi(Int32.Parse(value)).Insert(1, "."));

    }

	public CompositeType GetDataUsingDataContract(CompositeType composite)
	{
		if (composite == null)
		{
			throw new ArgumentNullException("composite");
		}
		if (composite.BoolValue)
		{
			composite.StringValue += "Suffix";
		}
		return composite;
	}
    internal static string CalculatePi(int digits)
    {
        digits++;

        uint[] x = new uint[digits * 10 / 3 + 2];
        uint[] r = new uint[digits * 10 / 3 + 2];

        uint[] pi = new uint[digits];

        for (int j = 0; j < x.Length; j++)
            x[j] = 20;

        for (int i = 0; i < digits; i++)
        {
            uint carry = 0;
            for (int j = 0; j < x.Length; j++)
            {
                uint num = (uint)(x.Length - j - 1);
                uint dem = num * 2 + 1;

                x[j] += carry;

                uint q = x[j] / dem;
                r[j] = x[j] % dem;

                carry = q * num;
            }


            pi[i] = (x[x.Length - 1] / 10);


            r[x.Length - 1] = x[x.Length - 1] % 10; ;

            for (int j = 0; j < x.Length; j++)
                x[j] = r[j] * 10;
        }

        var result = "";

        uint c = 0;

        for (int i = pi.Length - 1; i >= 0; i--)
        {
            pi[i] += c;
            c = pi[i] / 10;

            result = (pi[i] % 10).ToString() + result;
        }

        return result;
    }
}
