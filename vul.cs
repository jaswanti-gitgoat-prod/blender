using System;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;

namespace VulnerableApp
{
    class Program
    {
        // Hardcoded credentials – CWE-798
        private static string dbUser = "admin";
        private static string dbPass = "pass123";

        static void Main(string[] args)
        {
            string userInput = args.Length > 0 ? args[0] : "default";

            SqlInjection(userInput);
            CommandInjection(userInput);
            PathTraversal(userInput);
            InsecureLogging(userInput);
        }

        // SQL Injection – CWE-89
        static void SqlInjection(string input)
        {
            string connString = $"Server=localhost;Database=TestDB;User Id={dbUser};Password={dbPass};";
            SqlConnection conn = new SqlConnection(connString);
            conn.Open();

            string query = $"SELECT * FROM Users WHERE Username = '{input}'";
            SqlCommand cmd = new SqlCommand(query, conn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Console.WriteLine($"User: {reader["Username"]}");
            }

            conn.Close();
        }

        // Command Injection – CWE-78
        static void CommandInjection(string input)
        {
            string command = "ping " + input;
            Process.Start("cmd.exe", "/C " + command);  // Unsafe input execution
        }

        // Path Traversal – CWE-22
        static void PathTraversal(string filename)
        {
            string filePath = @"C:\Users\Public\" + filename;
            if (File.Exists(filePath))
            {
                string content = File.ReadAllText(filePath);
                Console.WriteLine("File content: " + content);
            }
            else
            {
                Console.WriteLine("File not found");
            }
        }

        // Insecure Logging of sensitive input – CWE-532
        static void InsecureLogging(string input)
        {
            File.AppendAllText("log.txt", "User input: " + input + Environment.NewLine);
        }
    }
}
