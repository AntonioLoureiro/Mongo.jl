using Mongo, LibBSON

export export2Mongo, query_all_collection, query_collection, update_collection

function export2Mongo(client::Mongo.MongoClient, db::String, collection::String, file)
    col = Mongo.MongoCollection(client, db, collection)
    qd=cursor_dicts(Mongo.find(col,()))
    insert_bulk(col,LibBSON.BSONObject.(file))
end


"""
	query_all_collection
Get the entire collection stored in Mongo.
"""
function query_all_collection(client::Mongo.MongoClient, db::String, collection::String)
    coll = MongoCollection(client, db, collection)
    cursor = Mongo.find(coll, Mongo.query())
    ret = cursor_dicts(cursor)
    return ret
end




"""
    query_collection
Query from Mongo according to a Pair of arguments.

Return all orange cats:
    query_collection("db", "cats", ("color"=>"orange"))
"""
function query_collection(client::Mongo.MongoClient, db::String, collection::String, p::Pair)
    coll = MongoCollection(client, db, collection)
    query_cursor = Mongo.find(coll, query(p))
    return cursor_dicts(query_cursor)
end



"""
    update_collection

Update the a specific id on a collection.
Allows one pair ("field"=>"new_value") or Array of pairs.

Example:

Update a specific field.
    update_collection("db", "cats", _id,
                      ("age"=>7))

Update multiple fields.
    update_collection("db", "cats", _id,
                [("age"=>10),("color"=>"orange")])

"""
function update_collection(client::Mongo.MongoClient, db::String, collection::String, _id, p::Pair)
    coll = MongoCollection(client, db, collection)
    update(coll, ("_id"=>_id), set(p))
end

function update_collection(client::Mongo.MongoClient, db::String, collection::String, _id, p::AbstractArray)
    coll = MongoCollection(client, db, collection)
    for i in 1:length(p)
        update(coll, ("_id"=>_id), set(p[i]))
    end
end
