//
//  PlanetaDao.swift
//  Planeta
//
//  Created by Aplimovil on 12/8/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import Foundation
import SQLite
import Parse

class PlanDao{
    
    var db:Connection!
    let table = Table("plan")
    let id = Expression<Int64>("id")
    let nombre = Expression<String>("nombre")
    let description = Expression<String>("description")
    let date = Expression<String>("date")
    let place = Expression<String>("place")
    let id_plan = Expression<String>("is_plan")
    
    
    init(){
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .DocumentDirectory, .UserDomainMask, true
                ).first!
            
            db = try Connection("\(path)/plan.sqlite3")
            try db!.run(table.create(ifNotExists:true){ t in
                t.column(id, primaryKey: true)
                t.column(nombre)
                t.column(description)
                t.column(date)
                t.column(place)
                t.column(id_plan)
                })
            
        }catch{
            db = nil
        }
        
    }
    
    func insert(p:Plan)-> Int64{
        let insert = table.insert(nombre <- p.title,  description <- p.descripcion, date <- p.date, place <- p.place, id_plan <- p.id_Plan)
        
        do{
            return try db.run(insert)
        }catch{
            return -1
        }
    }
    
    func update(p:Plan){
        let filter = table.filter(id_plan == p.id_Plan)
        let update = filter.update(nombre <- p.title,  description <- p.descripcion, date <- p.date, place <- p.place, id_plan <- p.id_Plan)
        
        do{
            try db.run(update)
        }catch{
        }
        
    }
    
    func delete(p:Plan){
        let filter = table.filter(id_plan == p.id_Plan)
        do{
            try db.run(filter.delete())
        }catch{
        }
        
        
    }
    
    func findById(idPlan:String)->Plan?{
        let filter = table.filter(id_plan == idPlan)
        let data = db.prepare(filter)
        var row:Row?
        
        
        for r  in data {
            row = r
            break
        }
        
        return rowToPlan(row)
    }
    
    func getAll()->[Plan]{
        return rowsToList(db.prepare(table))
        
    }
    
    
    
    
    private func rowsToList(rows:AnySequence<Row>)->[Plan]{
        var data:[Plan] = [Plan]()
        
        for r in rows{
            data.append(rowToPlan(r)!)
        }
        
        return data
    }
    
    private func rowToPlan(row:Row? )->Plan?{
        if row == nil{
            return nil
        }else{
            var p:Plan =  Plan()
            p.id_Plan = row![id_plan]
            p.title = row![nombre]
            p.descripcion = row![description]
            p.date = row![date]
            p.place = row![place]
            return p
        }
    }
    
        
}