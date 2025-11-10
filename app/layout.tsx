import type { Metadata } from "next";
import "./globals.css";
import { Providers } from "./providers";

export const metadata: Metadata = {
  title: "EchoScroll - The Eternal Blockchain Library",
  description: "A magical Web3 library where scrolls can only be vanished by secret spells",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="font-sans antialiased bg-gradient-to-br from-mystic-blue via-purple-900 to-mystic-purple min-h-screen">
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  );
}
