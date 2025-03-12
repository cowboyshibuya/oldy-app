//
//  Supabase.swift
//  oldy-app
//
//  Created by Spike Hermann on 12/03/2025.
//

import Foundation
import Supabase

let supabaseURL = (URL(string: "https://ogbawxmexfogfxynkufv.supabase.co"))
let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9nYmF3eG1leGZvZ2Z4eW5rdWZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE2NDE0NzAsImV4cCI6MjA1NzIxNzQ3MH0.3lL9UNkK2R9IQFGXutUsz06M4uNWX00pCVztkHg-KsY"

let supabase = SupabaseClient(supabaseURL: supabaseURL!, supabaseKey: supabaseKey)
