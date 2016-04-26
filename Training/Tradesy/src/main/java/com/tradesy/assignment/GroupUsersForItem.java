package com.tradesy.assignment;

import org.apache.pig.EvalFunc;
import org.apache.pig.data.BagFactory;
import org.apache.pig.data.DataBag;
import org.apache.pig.data.Tuple;
import org.apache.pig.data.TupleFactory;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by: Leonid Furman
 * Date:       4/25/16.
 */
public class GroupUsersForItem extends EvalFunc<DataBag> {
    private BagFactory bagFactory = BagFactory.getInstance();

    @Override
    public DataBag exec(Tuple input) throws IOException {
        if (input == null || input.size() == 0) {
            return null;
        }

        // aggregate user counts
        Map<Integer, Integer> userCounts = new HashMap<>();
        try {
            DataBag inputBag = (DataBag)input.get(0);
            Integer userId;
            Integer userCnt;
            for (Tuple tuple : inputBag) {
                userId = (Integer)tuple.get(0);
                userCnt = userCounts.get(tuple.get(0));
                if (userCnt == null) {
                    userCounts.put(userId, 1);
                } else {
                    userCounts.put(userId, userCnt + 1);
                }
            }

            // generate output bag
            DataBag outputBag = bagFactory.newDefaultBag();
            userCounts.forEach((key, value) -> {
                Tuple tuple = TupleFactory.getInstance().newTuple();
                tuple.append(key);
                tuple.append(value);
                outputBag.add(tuple);
            });
            return outputBag;
        } catch (Exception ex){
            throw new IOException("Caught exception processing input row ", ex);
        }
    }
}
