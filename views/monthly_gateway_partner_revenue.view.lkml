# If necessary, uncomment the line below to include explore_source.
# include: "netsuite_spreedly.model.lkml"


  view: monthly_gateway_partner_revenue {

    derived_table: {
      explore_source: transaction_lines {
        column: gateway_type { field: customers.gateway_type }
        column: ending_month { field: accounting_periods.ending_month }
        column: sum_transaction_amount {}

        filters: {
          field: accounts.type_name
          value: "Income,Other Income"
        }

        filters: {
          field: transaction_lines.is_transaction_non_posting
          value: "No"

        }

        filters: {
          field: accounts.name
          value: "SGP Annual Membership Fee,SGP Revenue Share,PGP Revenue Share"
        }
      }
    }

    dimension: primary_key {
      sql: ${gateway_type}||${ending_month} ;;
      primary_key: yes

    }

    dimension: gateway_type {}

    dimension: ending_month {
      type: date_month
    }

    dimension: sum_transaction_amount {
      value_format: "$#,##0.00"
      type: number
    }

    dimension: indirect_revenue {
      type: number
      sql: ${sum_transaction_amount}*${monthly_org_partner_gateway_transactions.count}/${monthly_partner_gateway_transactions.count} ;;
    }

    measure: total_indirect_revenue {
      type: sum
      sql: ${indirect_revenue} ;;
    }

   measure: count {
      type: count
    }

  # scope for the view to pull in the dimensions need three views to create this calculations...
  # step 2 build subquery out of this and join to Netsuite explore...

  }
