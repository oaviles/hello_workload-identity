using Azure.Identity;
using Azure.Storage.Blobs;
using System;

class Program
{
    static async Task Main(string[] args)
    {
        try {
            var storageAccountName = Environment.GetEnvironmentVariable("STORAGE_ACCOUNT_NAME");
            var storageAccountContainerName = Environment.GetEnvironmentVariable("STORAGE_ACCOUNT_CONTAINER_NAME");
            var blobServiceClient = new BlobServiceClient(new Uri($"https://{storageAccountName}.blob.core.windows.net/"), new DefaultAzureCredential());
            var containerClient = blobServiceClient.GetBlobContainerClient($"{storageAccountContainerName}");
            await containerClient.CreateIfNotExistsAsync();
            Console.WriteLine($"Container/Folder {storageAccountContainerName}  was successfully created.");
        }
        catch (Exception ex) {
            Console.WriteLine(ex.Message);
        }
    }
}